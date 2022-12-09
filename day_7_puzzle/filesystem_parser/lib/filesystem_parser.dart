class FilesystemParser {
  List<String> terminalLog;
  List<TerminalLine> terminalLines = [];
  int totalFilesystemSpace = 0;
  DirectoryNode rootDirectory = RootNode();
  List<DirectoryNode> directories = [];

  FilesystemParser(this.terminalLog, this.totalFilesystemSpace) {
    parseTerminalLog();
    // print('Directories: \n');
    // directories.forEach((directory) {
    //   print("${directory.name}: ${directory.totalFileSize}\n");
    // });
  }

  void parseTerminalLog() {
    terminalLog.forEach((logLine) {
      final termLogLine = TerminalLine(logLine);
      terminalLines.add(termLogLine);
    });

    DirectoryNode currentDirectoryCursor = rootDirectory;
    directories.add(currentDirectoryCursor);

    for (var lineCursor = 0; lineCursor < terminalLines.length; lineCursor++) {
      final currentLine = terminalLines[lineCursor];
      if (currentLine.isCommand) {
        if (currentLine.commandAndArg[0] == "cd") {
          if (currentLine.commandAndArg[1] == "..") {
            currentDirectoryCursor = currentDirectoryCursor == rootDirectory
                ? rootDirectory
                : currentDirectoryCursor.parentNode!;
          } else if (currentLine.commandAndArg[1] == "/") {
            currentDirectoryCursor = rootDirectory;
            continue;
          } else {
            currentDirectoryCursor = currentDirectoryCursor.childNodes
                .whereType<DirectoryNode>()
                .where((node) => node.name == currentLine.commandAndArg[1])
                .first;
            continue;
          }
        }
        if (currentLine.commandAndArg[0] == "ls") {
          continue;
        }
      } else if (currentLine.isDirectoryListing) {
        final matchNode = currentDirectoryCursor.childNodes
            .whereType<DirectoryNode>()
            .where((node) => node.name == currentLine.directoryName);

        if (matchNode.isEmpty) {
          final newDirectory =
              DirectoryNode(currentDirectoryCursor, currentLine.directoryName);
          currentDirectoryCursor.addChild(newDirectory);
          directories.add(newDirectory);
        }
      } else if (currentLine.isFileListing) {
        final matchNode = currentDirectoryCursor.childNodes
            .whereType<FileNode>()
            .where((node) => node.name == currentLine.fileNameAndSize[0]);

        if (matchNode.isEmpty) {
          currentDirectoryCursor.addChild(FileNode(
              currentDirectoryCursor,
              currentLine.fileNameAndSize[0],
              int.parse(currentLine.fileNameAndSize[1])));
        }
      }
    }
  }

  int totalFileSizeOfDirectoriesLessThan(int maxDirectorySize) {
    final directoriesUnderMax = directories
        .where((directory) => directory.totalFileSize < maxDirectorySize);
    var totalFileSize = 0;
    directoriesUnderMax.fold<int>(totalFileSize,
        (previousValue, directory) => totalFileSize += directory.totalFileSize);
    return totalFileSize;
  }

  DirectoryNode directoryThatWillFree(int neededFreeSpace) {
    final freeSpace = totalFilesystemSpace - rootDirectory.totalFileSize;
    final targetSpaceToFree = neededFreeSpace - freeSpace;
    final List<DirectoryNode> directoriesLargeEnough = directories
        .where((directory) => directory.totalFileSize >= targetSpaceToFree)
        .toList();
    directoriesLargeEnough.sort(((a, b) => a.totalFileSize - b.totalFileSize));
    return directoriesLargeEnough.first;
  }
}

abstract class FilesystemNode {
  final String name;
  int _size = 0;
  DirectoryNode? parentNode;

  FilesystemNode(this.parentNode, this.name);

  int get totalFileSize {
    return _size;
  }
}

class RootNode extends DirectoryNode {
  RootNode() : super(null, "/");
}

class FileNode extends FilesystemNode {
  FileNode(parent, name, size) : super(parent, name) {
    _size = size;
  }
}

class DirectoryNode extends FilesystemNode {
  final List<FilesystemNode> childNodes = [];

  DirectoryNode(parent, name) : super(parent, name);

  @override
  int get totalFileSize {
    if (_size == 0) {
      final childDirectoryNodes = childNodes.whereType<DirectoryNode>();
      final childFileNodes = childNodes.whereType<FileNode>();

      childNodes.forEach((fileNode) {
        _size += fileNode.totalFileSize;
      });
    }
    return _size;
  }

  void addChild(FilesystemNode filesystemNode) {
    filesystemNode.parentNode = this;
    childNodes.add(filesystemNode);
  }
}

class TerminalLine {
  final String logLine;
  TerminalLine(this.logLine);

  bool get isCommand {
    return logLine.substring(0, 1) == "\$";
  }

  bool get isDirectoryListing {
    return logLine.substring(0, 3) == "dir";
  }

  bool get isFileListing {
    return !isCommand && !isDirectoryListing;
  }

  String get directoryName {
    var dirName = "";
    if (isDirectoryListing) {
      dirName = logLine.split(" ")[1];
    }
    return dirName;
  }

  List<String> get fileNameAndSize {
    final List<String> fileAndSize = [];
    if (isFileListing) {
      final parsedFileListing = logLine.split(" ");
      if (parsedFileListing[1].isNotEmpty) {
        fileAndSize.add(parsedFileListing[1]);
      }
      if (parsedFileListing[0].isNotEmpty) {
        fileAndSize.add(parsedFileListing[0]);
      }
    }
    return fileAndSize;
  }

  List<String> get commandAndArg {
    final List<String> commandAndArg = [];
    if (isCommand) {
      final parsedCommand = logLine.split(" ");
      if (parsedCommand[1].isNotEmpty) {
        commandAndArg.add(parsedCommand[1]);
      }
      if (parsedCommand[1] == "cd" && parsedCommand[2].isNotEmpty) {
        commandAndArg.add(parsedCommand[2]);
      }
    }
    return commandAndArg;
  }
}
