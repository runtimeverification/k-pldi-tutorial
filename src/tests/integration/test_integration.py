from pathlib import Path

import pytest

from kimp.kimp import KIMP

IMP_EXAMPLES_DIR = Path(__file__).parent.parent.parent.parent / 'examples' / 'imp'

IMP_TEST_DATA = [(path, path.stem) for path in IMP_EXAMPLES_DIR.glob('*.imp')]


@pytest.mark.parametrize(
    ('input_path', 'test_id'),
    IMP_TEST_DATA,
    ids=[test_id for _, test_id in IMP_TEST_DATA],
)
def test_integration(kimp: KIMP, input_path: Path, test_id: str) -> None:
    result = kimp.run_imp_file(input_path)
    rc, errs = kimp.postprocess(result)

    assert rc == 0
    assert len(errs) == 0
