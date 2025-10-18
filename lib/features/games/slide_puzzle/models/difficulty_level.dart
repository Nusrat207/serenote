enum DifficultyLevel {
  easy(3, '3x3', 'Easy'),
  medium(4, '4x4', 'Medium'),
  hard(5, '5x5', 'Hard');

  final int gridSize;
  final String gridText;
  final String displayName;

  const DifficultyLevel(this.gridSize, this.gridText, this.displayName);
}