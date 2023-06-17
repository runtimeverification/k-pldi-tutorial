from pathlib import Path

import pytest
from pyk.cli.utils import dir_path
from pyk.kbuild import KBuild, Package
from pytest import Config, Parser, TempPathFactory

from kimp.kimp import KIMP


def pytest_addoption(parser: Parser) -> None:
    parser.addoption('--no-skip', action='store_true', default=False, help='do not skip tests')
    parser.addoption(
        '--kbuild-dir',
        dest='kbuild_dir',
        type=dir_path,
        help='Existing kbuild cache directory. Example: `~/.kbuild`. Note: tests will fail of it is invalid. Call `kbuild kompile` to populate it.',
    )


@pytest.fixture(scope='session')
def kbuild_dir(pytestconfig: Config, tmp_path_factory: TempPathFactory) -> Path:
    existing_kbuild_dir = pytestconfig.getoption('kbuild_dir')
    if not existing_kbuild_dir:
        return tmp_path_factory.mktemp('kbuild')
    else:
        assert isinstance(existing_kbuild_dir, Path)
        return existing_kbuild_dir


@pytest.fixture(scope='session')
def kbuild(kbuild_dir: Path) -> KBuild:
    return KBuild(kbuild_dir)


@pytest.fixture(scope='session')
def package() -> Package:
    return Package.create(Path('kbuild.toml'))


@pytest.fixture(scope='session')
def definition_dir(kbuild: KBuild, package: Package) -> Path:
    return kbuild.kompile(package, 'llvm')


@pytest.fixture(scope='session')
def kimp(definition_dir: Path) -> KIMP:
    return KIMP(definition_dir=definition_dir)
