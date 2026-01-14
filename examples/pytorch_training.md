# Using mlgpu with PyTorch

This guide shows how to monitor PyTorch training with mlgpu.

## Basic Setup

### 1. Configure your training script to log progress

```python
import logging

# Set up logging
logging.basicConfig(
    filename='train.log',
    level=logging.INFO,
    format='%(asctime)s - %(message)s'
)

# In your training loop
for epoch in range(num_epochs):
    for step, batch in enumerate(dataloader):
        # ... training code ...
        loss = criterion(output, target)

        # Log progress (mlgpu will parse this)
        if step % 100 == 0:
            logging.info(f"Epoch {epoch}/{num_epochs}, Step {step}, Loss: {loss.item():.4f}")
```

### 2. Run mlgpu in a separate terminal

```bash
mlgpu -l ./train.log -i 50000
```

## Ultralytics YOLO

YOLO already outputs progress to stdout. Capture it:

```bash
# Start training with output capture
yolo train model=yolov8n.pt data=coco.yaml epochs=100 2>&1 | tee train.log &

# Monitor in another terminal
mlgpu -l train.log -i 10000
```

## PyTorch Lightning

```python
from pytorch_lightning.callbacks import Callback

class MLGPUCallback(Callback):
    def __init__(self, log_file='train.log'):
        self.log_file = log_file

    def on_train_batch_end(self, trainer, pl_module, outputs, batch, batch_idx):
        if batch_idx % 100 == 0:
            loss = outputs['loss'].item() if isinstance(outputs, dict) else outputs.item()
            with open(self.log_file, 'a') as f:
                f.write(f"Step {trainer.global_step}, Loss: {loss:.4f}\n")

# Use the callback
trainer = Trainer(callbacks=[MLGPUCallback()])
```

Then monitor:
```bash
mlgpu -l train.log -i 100000
```

## Custom Log Format

mlgpu supports various log formats:

```
# All of these work:
Epoch 5/100, Loss: 0.234
Step 1000, loss=0.234
iteration: 1000, loss: 0.234
[Epoch 5] loss: 0.234
step=1000 loss=0.234
```

## JSON Output for Dashboards

Integrate mlgpu into your monitoring dashboard:

```python
import subprocess
import json

def get_training_status():
    result = subprocess.run(['mlgpu', '--json'], capture_output=True, text=True)
    return json.loads(result.stdout)

status = get_training_status()
print(f"Progress: {status['training']['progress_pct']}%")
print(f"Loss: {status['training']['loss']}")
print(f"GPU Usage: {status['gpu']['device_util']}%")
```

## Tips

1. **Log frequently** - mlgpu reads the last lines of the log file
2. **Use consistent format** - Include "loss" keyword for automatic detection
3. **Include iteration/step** - For accurate progress tracking
4. **Specify total iterations** - Use `-i` flag for accurate ETA
