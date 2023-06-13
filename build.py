import os
import shutil

# Get the current directory
current_dir = os.getcwd()

# Get the list of files in the current directory
files = os.listdir(current_dir)

# Delete all directories except for `flutter_app` and `.git`
# Delete all files except for `build.py`, 'README.md' and `.gitignore`
exceptions = ['flutter_app', '.git', 'build.py', 'README.md', '.gitignore']
for file in files:
    if file not in exceptions:
        if os.path.isdir(file):
            print('Deleting directory:', file)
            shutil.rmtree(file, ignore_errors=True)
        else:
            print('Deleting file:', file)
            os.remove(file)

# Change the current directory to the `flutter_app` directory
os.chdir('flutter_app')

# Build the Flutter app
os.system('flutter build web')

# Iterate through the files in the `build/web` directory
for file in os.listdir('build/web'):
    # Move the file to the parent directory
    shutil.move(os.path.join('build/web', file), current_dir)
