# Contributing to mlgpu

Thank you for your interest in contributing to mlgpu!

## How to Contribute

### Bug Reports

1. Check if the issue already exists
2. Create a new issue with:
   - macOS version
   - Apple Silicon chip (M1/M2/M3/M4)
   - Steps to reproduce
   - Expected vs actual behavior

### Feature Requests

Open an issue describing:
- The problem you're trying to solve
- Your proposed solution
- Example use cases

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test on Apple Silicon Mac
5. Submit a PR with clear description

## Development Setup

```bash
git clone https://github.com/artifactiq/mlgpu.git
cd mlgpu
chmod +x mlgpu

# Test locally
./mlgpu --help
./mlgpu --json
```

## Code Style

- Use 4-space indentation
- Add comments for complex logic
- Keep functions small and focused
- Test with shellcheck: `shellcheck mlgpu`

## Areas for Contribution

- [ ] TensorBoard log parsing
- [ ] MLflow integration
- [ ] Weights & Biases support
- [ ] Neptune.ai support
- [ ] Ray Train support
- [ ] Sparkline charts for historical data
- [ ] Notification integrations (Slack, Discord)
- [ ] Web dashboard mode
- [ ] Unit tests

## Testing

Before submitting:
```bash
# Basic functionality
./mlgpu --version
./mlgpu --help
./mlgpu --json | python3 -m json.tool

# With training (if available)
./mlgpu -l /path/to/train.log
```

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
