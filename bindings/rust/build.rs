#![allow(unused_imports)]

extern crate cc;

use std::env;
use std::path::{Path, PathBuf};

#[cfg(target_env = "msvc")]
fn assembly(file_vec: &mut Vec<PathBuf>, base_dir: &Path, arch: &String) {
    let sfx = match arch.as_str() {
        "x86_64" => "x86_64",
        "aarch64" => "armv8",
        _ => "unknown",
    };
    let files =
        glob::glob(&format!("{}/win64/*-{}.asm", base_dir.display(), sfx))
            .expect("unable to collect assembly files");
    for file in files {
        file_vec.push(file.unwrap());
    }
}

#[cfg(not(target_env = "msvc"))]
fn assembly(file_vec: &mut Vec<PathBuf>, base_dir: &Path, _: &String) {
    file_vec.push(base_dir.join("assembly.S"))
}

fn main() {
    /*
     * Use pre-built libblst.a if there is one. This is primarily
     * for trouble-shooting purposes. Idea is that libblst.a can be
     * compiled with flags independent from cargo defaults, e.g.
     * '../../build.sh -O1 ...'.
     */
    if Path::new("libblst.a").exists() {
        println!("cargo:rustc-link-search=.");
        println!("cargo:rustc-link-lib=blst");
        return;
    }

    // Set CC environment variable to choose alternative C compiler.
    // Optimization level depends on whether or not --release is passed
    // or implied.
    let mut cc = cc::Build::new();

    let blst_base_dir = match env::var("BLST_SRC_DIR") {
        Ok(val) => PathBuf::from(val),
        Err(_) => {
            let local_blst = PathBuf::from("blst");
            if local_blst.exists() {
                local_blst
            } else {
                // Reach out to ../.., which is the root of the blst repo.
                // Use an absolute path to avoid issues with relative paths
                // being treated as strings by `cc` and getting concatenated
                // in ways that reach out of the OUT_DIR.
                env::current_dir()
                    .expect("can't access current directory")
                    .parent()
                    .and_then(|dir| dir.parent())
                    .expect(
                        "can't access parent of parent of current directory",
                    )
                    .into()
            }
        }
    };
    println!("Using blst source directory {}", blst_base_dir.display());

    let c_src_dir = blst_base_dir.join("src");

    let mut file_vec = vec![c_src_dir.join("server.c")];

    // account for cross-compilation
    let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();
    if target_arch.eq("x86_64") || target_arch.eq("aarch64") {
        assembly(&mut file_vec, &blst_base_dir.join("build"), &target_arch);
    } else {
        cc.define("__BLST_NO_ASM__", None);
    }
    match (cfg!(feature = "portable"), cfg!(feature = "force-adx")) {
        (true, false) => {
            println!("Compiling in portable mode without ISA extensions");
            cc.define("__BLST_PORTABLE__", None);
        }
        (false, true) => {
            if target_arch.eq("x86_64") {
                println!("Enabling ADX support via `force-adx` feature");
                cc.define("__ADX__", None);
            } else {
                println!("`force-adx` is ignored for non-x86_64 targets");
            }
        }
        (false, false) => {
            #[cfg(target_arch = "x86_64")]
            if target_arch.eq("x86_64") && std::is_x86_feature_detected!("adx")
            {
                println!("Enabling ADX because it was detected on the host");
                cc.define("__ADX__", None);
            }
        }
        (true, true) => panic!(
            "Cannot compile with both `portable` and `force-adx` features"
        ),
    }
    cc.flag_if_supported("-mno-avx") // avoid costly transitions
        .flag_if_supported("-fno-builtin-memcpy")
        .flag_if_supported("-Wno-unused-command-line-argument");
    if !cfg!(debug_assertions) {
        cc.opt_level(2);
    }
    cc.files(&file_vec).compile("libblst.a");
}
