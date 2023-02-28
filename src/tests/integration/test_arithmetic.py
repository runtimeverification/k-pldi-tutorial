from pathlib import Path

import pytest
from pyk.kbuild import KBuild, Package


@pytest.fixture(scope='module')
def llvm_dir(package: Package, kbuild: KBuild) -> Path:
    return kbuild.kompile(package, 'arithmetic')


def test_arithmetic(llvm_dir: Path) -> None:
    print(llvm_dir)
