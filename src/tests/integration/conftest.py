from pathlib import Path

import pytest
from pyk.kbuild import KBuild, Package
from pytest import TempPathFactory


@pytest.fixture(scope='session')
def kbuild(tmp_path_factory: TempPathFactory) -> KBuild:
    return KBuild(tmp_path_factory.mktemp('kbuild'))


@pytest.fixture(scope='session')
def package() -> Package:
    return Package.create(Path('kbuild.toml'))
