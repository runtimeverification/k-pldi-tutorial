import subprocess
from pathlib import Path
from typing import Collection, Tuple

from pyk.kast.inner import KApply, KInner, KToken
from pyk.kast.manip import cell_label_to_var_name, flatten_label, get_cell
from pyk.kore import syntax as kore
from pyk.kore.parser import KoreParser
from pyk.ktool.kprint import KPrint
from pyk.ktool.krun import KRun


def _token_to_string(token: KInner) -> str | None:
    if isinstance(token, KToken):
        if token.sort.name == 'String':
            return token.token[1:-1]

    return None


def _token_to_int(token: KInner) -> int | None:
    if isinstance(token, KToken):
        if token.sort.name == 'Int':
            return int(token.token)

    return None


def _item_to_string(item: KInner) -> str | None:
    if isinstance(item, KApply):
        if item.label.name == 'ListItem' and len(item.args) == 1:
            return _token_to_string(item.args[0])

    return None


def _list_strings(items: Collection[KInner]) -> list[str]:
    return [item for item in [_item_to_string(i) for i in items] if item is not None]


def _error_list(term: KInner) -> list[str]:
    errors_cell = get_cell(term, cell_label_to_var_name('<errors>'))
    errors = flatten_label('_List_', errors_cell)
    return _list_strings(errors)


def _exit_code(term: KInner) -> int:
    exit_cell = get_cell(term, cell_label_to_var_name('<exit-code>'))
    return _token_to_int(exit_cell) or 0


class KIMP(KRun):
    _imp_parser: Path
    _definition_dir: Path

    def __init__(
        self,
        definition_dir: Path,
    ) -> None:
        KRun.__init__(self, definition_dir)
        self._definition_dir = definition_dir
        self._imp_parser = definition_dir / 'parser_Pgm_IMP-SYNTAX'

    def run_imp_file(
        self,
        main_file: Path,
    ) -> kore.Pattern:
        return self.run_kore_config({'PGM': self.parse_imp(main_file)})

    def postprocess(self, pattern: kore.Pattern) -> Tuple[int, list[str]]:
        kprint = KPrint(self._definition_dir)
        kast = kprint.kore_to_kast(pattern)

        return (_exit_code(kast), _error_list(kast))

    def parse_imp(self, file: Path) -> kore.Pattern:
        command = [str(self._imp_parser), str(file)]
        result = subprocess.run(command, stdout=subprocess.PIPE, check=True, text=True)
        return KoreParser(result.stdout).pattern()
