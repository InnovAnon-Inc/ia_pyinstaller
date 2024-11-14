#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" Standalone """

import asyncio
from pathlib                                 import Path
from typing                                  import List, Optional, Iterable
from typing                                  import ParamSpec

import PyInstaller.__main__
from structlog                               import get_logger

#from ia_check_output                         import acheck_output

P     :ParamSpec = ParamSpec('P')
logger           = get_logger()

##
#
##

def _pyinstaller(project_name:str,)->None:
	warn_str :str  = str(f'warn-{project_name}.txt')
	Path('build', project_name, warn_str).touch()

	hook_str :str  = str(f'hook-{project_name}.py')
	assert Path(hook_str).is_file()

	main_str :str  = str(f'main-{project_name}.py')
	assert Path(main_str).is_file()

	return [
		'--onefile',
		'--additional-hooks-dir', '.',
		'--name',                 project_name,
		main_str,
	]

async def _main()->None:
	project_name:str       = Path().resolve().name
	assert Path(project_name).is_dir() # module dir
	args        :List[str] = _pyinstaller(project_name=project_name,)
	PyInstaller.__main__.run(args,)
	#result      :str       = await acheck_output(['pyinstaller', *args],)
	#await logger.ainfo('PyInstaller: %s', result,)

def main()->None:
	asyncio.run(_main())

if __name__ == '__main__':
	main()

__author__:str = 'you.com' # NOQA
