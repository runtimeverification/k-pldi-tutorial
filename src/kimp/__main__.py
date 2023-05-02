import os
import sys
from argparse import ArgumentParser
from pathlib import Path
from typing import Any

from pyk.cli_utils import dir_path, file_path

from kimp.kimp import KIMP


def exec_run(
    definition_dir: Path,
    input_file: Path,
    **kwargs: Any,
) -> None:
    kimp = KIMP(definition_dir=definition_dir)
    result = kimp.run_imp_file(main_file=input_file)
    rc, errors = kimp.postprocess(result)

    for err in errors:
        print(err, file=sys.stderr)

    sys.exit(rc)


def create_argument_parser() -> ArgumentParser:
    parser = ArgumentParser(prog='kimp')

    shared_args = ArgumentParser(add_help=False)
    shared_args.add_argument('--verbose', '-v', default=False, action='store_true', help='Verbose output')

    command_parser = parser.add_subparsers(dest='command', required=True, help='Command to execute')

    run_subparser = command_parser.add_parser('run', help='Run IMP program', parents=[shared_args])
    run_subparser.add_argument(
        '--definition-dir',
        dest='definition_dir',
        type=dir_path,
        help='Path to KIMP definition',
    )
    run_subparser.add_argument('input_file', type=file_path, help='Path to .imp file')

    return parser


def main() -> None:
    parser = create_argument_parser()
    args = parser.parse_args()

    if (not 'definition_dir' in vars(args)) or (not args.definition_dir):
        env_definition_dir = os.environ.get('KIMP_DEFINITION_DIR')
        if env_definition_dir:
            args.definition_dir = Path(env_definition_dir)
        else:
            raise RuntimeError(
                'Cannot find KIMP definition, plese specify either --definition-dir or KIMP_DEFINITION_DIR'
            )

    executor_name = 'exec_' + args.command.lower().replace('-', '_')
    if executor_name not in globals():
        raise AssertionError(f'Unimplemented command: {args.command}')

    execute = globals()[executor_name]
    execute(**vars(args))
