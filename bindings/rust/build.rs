extern crate bindgen;
extern crate cc;

use std::env;
use std::path::PathBuf;
use std::path::Path;
use std::process::Command;

fn main() {
    // TODO - could ls directory and find all files
    let asm_to_build = [
        "add_mod_256-x86_64",
        "add_mod_384-x86_64",
        "mulq_mont_256-x86_64",
        "mulx_mont_256-x86_64",
        "sha256-x86_64",
        "add_mod_384x384-x86_64",
        "inverse_mod_384-x86_64",
        "mulq_mont_384-x86_64",
        "mulx_mont_384-x86_64",
    ];

    let mut file_vec = Vec::new();

    let out_dir = env::var_os("OUT_DIR").unwrap();

    for a in asm_to_build.iter() {
        let dest_path = Path::new(&out_dir).join(a).with_extension("s");
        let src_path  = Path::new("../../src/asm/")
            .join(a).with_extension("pl");

        Command::new(&src_path)
            .args(&[">", dest_path.to_str().unwrap()])
            .status().unwrap();

        file_vec.push(dest_path);
    }

    file_vec.push(Path::new("../../src/").join("server.c"));

    // Set CC environment variable to choose alternative C compiler.
    // Optimization level depends on whether or not --release is passed
    // or implied. If default "release" level of 3 is deemed unsuitable,
    // modify 'opt-level' in [profile.release] in Cargo.toml.
    cc::Build::new()
        .flag("-march=native")
        .flag_if_supported("-mno-avx")  // avoid costly transitions
        .flag_if_supported("-Wno-unused-command-line-argument")
        .files(&file_vec)
        .compile("libblst.a");

    let bindings = bindgen::Builder::default()
        .header("../blst.h")
        .opaque_type("blst_pairing")
        .size_t_is_usize(true)
        .rustified_enum("BLST_ERROR")
        .generate()
        .expect("Unable to generate bindings");

    // Write the bindings to the $OUT_DIR/bindings.rs file.
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}
