// Copyright 2025 RISC Zero, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#![doc = include_str!("../README.md")]

use risc0_wrapper_methods::WRAPPER_ELF;
use risc0_zkvm::{default_executor, ExecutorEnv};

pub fn run_test() -> () {
    let env = ExecutorEnv::builder().build().unwrap();
    let prover = default_executor();
    assert!(prover.execute(env, WRAPPER_ELF).is_ok());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        run_test();
    }
}
