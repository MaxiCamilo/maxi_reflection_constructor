# Maxi Reflection Constructor

A powerful Dart library that automatically detects reflectable classes in your projects and generates reflection libraries with static, constant structures.

## Overview

**maxi_reflection_constructor** is a separate library designed to examine Dart projects, detect classes marked as reflectable (using annotations from `maxi_reflection`), and automatically generate corresponding reflector files. This enables compile-time reflection capabilities while maintaining static and constant structures.

### Key Features

- **Automatic Class Detection**: Scans your project for classes with reflectable annotations
- **Reflector Generation**: Generates reflection files in organized library structures
- **Static Structure**: Generated reflectors maintain constant, compile-time safe structures
- **Customizable Output**: Control destination folders and import paths
- **Project Independent**: Works across multiple Dart projects in your workspace

## How It Works

The library follows these steps:

1. **File Discovery**: Scans project directories for Dart files containing reflectable classes
2. **Analysis**: Parses each file to detect classes, fields, methods, and annotations
3. **Reflection Building**: Generates reflector files based on discovered classes
4. **Output Generation**: Writes the generated reflectors to a specified destination

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  maxi_reflection_constructor:
    path: ../maxi_reflection_constructor
```

## Usage

### Recommended: Using Test Files

The recommended approach is to create a dedicated test file with a `test()` function that runs the reflector generator:

```dart
import 'package:maxi_reflection_constructor/maxi_reflection_constructor.dart';
import 'package:maxi_reflection_constructor/src/analyzer/folder_reflected_file_finder.dart';
import 'package:test/test.dart';

void main() {
  test('Generate reflectors', () async {
    final builder = ReflectorBuilder(
      prefix: 'my_project',
      // Optional: specify which files to search
      searcher: FolderReflectedFileFinder(
        folderAddress: FolderReference(isLocal: true, name: 'test', router: '..'),
      ),
      // Optional: specify output folder (defaults to lib/src/reflection/generated)
      destination: FolderReference(isLocal: true, name: 'reflection', router: '../test'),
      // Optional: additional imports to include in generated files
      extraImports: const ['../../classes/first.dart'],
    );

    final result = await builder.execute();
    expect(result.itsCorrect, true);
  });
}
```

### Running the Generator

Execute the test to generate reflectors:

```bash
dart test test/generate_reflectors_test.dart
```

## Core Components

### ReflectorBuilder

Main class responsible for orchestrating the reflection generation process.

**Parameters:**
- `prefix`: Prefix for generated reflector files
- `searcher`: (Optional) Custom file finder. Defaults to `FolderReflectedFileFinder`
- `destination`: (Optional) Output folder. Defaults to `lib/src/reflection/generated`
- `extraImports`: (Optional) Additional import statements to include

### FileAnalizer

Analyzes individual Dart files to detect reflectable classes and their members.

### FolderReflectedFileFinder

Automatically discovers all Dart files in a folder containing reflectable classes.

### Generated Entities

The library exports detection entities that represent discovered code elements:

- `DetectedClass`: Represents a reflectable class
- `DetectedField`: Represents class fields
- `DetectedMethod`: Represents class methods
- `DetectedMethodParameter`: Represents method parameters
- `DetectedAnnotation`: Represents annotations on classes/members
- `DetectedEnum`: Represents enum types
- `DetectedEnumOption`: Represents enum values

## Output Structure

Generated reflectors are organized in the following structure:

```
lib/src/reflection/
├── generated/
│   ├── reflector_1.dart
│   ├── reflector_2.dart
│   └── ...
└── ...
```

Each generated file contains static, constant reflection metadata for the corresponding source classes.

## Advanced Usage

### Custom File Searchers

Implement your own file searcher by creating a `Functionality<List<FileOperator>>`:

```dart
final customSearcher = MyCustomSearcher();

final builder = ReflectorBuilder(
  prefix: 'custom',
  searcher: customSearcher,
);
```

### Custom Destinations

Specify a custom output folder:

```dart
final builder = ReflectorBuilder(
  prefix: 'my_project',
  destination: FolderReference(isLocal: true, name: 'my_output', router: 'lib/reflection'),
);
```

### Additional Imports

Include extra import statements in generated reflectors:

```dart
final builder = ReflectorBuilder(
  prefix: 'my_project',
  extraImports: const [
    'package:my_package/models.dart',
    '../../utils/helpers.dart',
  ],
);
```

## Error Handling

The library uses a result-based error handling system. Always check the result of execution:

```dart
final result = await builder.execute();

if (result.itsFailure) {
  print('Generation failed: ${result.error}');
} else {
  print('Reflectors generated successfully');
}
```

## Integration with maxi_reflection

This library works in conjunction with `maxi_reflection` which provides:

- Annotation definitions for marking reflectable classes
- Runtime reflection utilities
- Type system support

## Best Practices

1. **Use Test Files**: Create a dedicated `generate_reflectors_test.dart` file for generation
2. **Run Regularly**: Run the generator whenever you add new reflectable classes
3. **Version Control Generated Files**: Generated reflectors are part of your project structure
4. **Organize Prefixes**: Use meaningful prefixes that correspond to your project module names
5. **Document Reflectable Classes**: Clearly mark which classes are reflectable in your code

## Performance Considerations

- The generator scans all Dart files in the specified folder
- Large projects may take time during initial generation
- Generated reflectors are compile-time safe with no runtime overhead
- Consider using multiple test files for different project modules if generation takes too long

## Related Packages

- **maxi_reflection**: Provides annotation system and runtime reflection utilities
- **maxi_framework**: Core framework providing file IO and result handling
- **analyzer**: Used internally for Dart code analysis

## License

See LICENSE file for details.

---

**Note**: This library is designed primarily for development and build-time use. It's recommended to include it in `dev_dependencies` unless you need runtime generation capabilities.
