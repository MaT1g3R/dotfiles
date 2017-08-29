"""Main File"""
from shutil import copy
import os


class Main:
    """The main run class"""

    def __init__(self):
        self.dest = ''
        self.ext = None
        self.files = []

    def get_src(self):
        """Get all files from source folder"""
        print("Please enter source folder path")
        while True:
            src = input()
            src = src.replace('\\', '//')
            if os.path.isdir(src):
                self.files = [os.path.join(dp, f) for dp, dn, filenames in os.walk(src)
                              for f in filenames if os.path.isfile(os.path.join(dp, f))]
                return
            else:
                print('Please enter a valid path')

    def get_dest(self):
        """Get the destination folder"""
        print('\nPlease enter the destination folder')
        while True:
            dest = input()
            dest = dest.replace('\\', '//')
            if os.path.isdir(dest):
                self.dest = dest
                return
            else:
                print('Please enter a valid path')

    def get_ext(self):
        """Get allowed file extensions"""
        print('\nPlease enter your desired file extensions to be copied, '
              'with the dot, separated by comma (,) leave blank for all files')
        ext = input()
        while True:
            if not ext or ext == '':
                return
            else:
                self.ext = tuple(ext.split(','))
                return

    def copy(self):
        """Copy the files"""
        success = True
        not_copied = []
        if self.ext is not None and self.ext != ():
            self.files = [f for f in self.files if f.endswith(self.ext)]
        for i in range(len(self.files)):
            print('copying {}/{}'.format(i + 1, len(self.files)), end="\r", flush=True)
            try:
                copy(self.files[i], self.dest)
            except Exception as e:
                print(self.files[i] + ' was not copied due to an exception\n{}'.format(e))
                success = False
                not_copied.append(self.files[i])
        print('Success!') if success else print('Those files were not copied due to an exception'
                                                '\n' + '\n'.join(not_copied))

    def run(self):
        """The main run method"""
        while True:
            self.get_src()
            self.get_dest()
            self.get_ext()
            self.copy()
            print('Quit? (y/n)')
            while True:
                quit_prompt = input()
                if quit_prompt == 'y':
                    quit_ = True
                    break
                elif quit_prompt == 'n':
                    quit_ = False
                    break
                else:
                    print("Please enter 'y' for yes or 'n' for no")
            if quit_:
                break

if __name__ == '__main__':
    run = Main()
    run.run()
