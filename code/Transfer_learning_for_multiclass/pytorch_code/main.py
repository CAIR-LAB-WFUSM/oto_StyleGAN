# -*- coding: utf-8 -*-
"""
Created on Thu Jan 25 11:46:45 2024

@author: secamala
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import models, datasets, transforms
from torch.utils.data import DataLoader

# Set device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Define data transforms
data_transform = transforms.Compose([
    transforms.RandomHorizontalFlip(),
    transforms.RandomVerticalFlip(),
    transforms.RandomRotation(0, 360),
    transforms.RandomResizedCrop(299),  # InceptionV3 input size
    transforms.ToTensor(),
])

# Define data loaders
root = '\\medctr.ad.wfubmc.edu\\dfs\\cialab$\\scratch\\cialab\\binol\\Projects\\Eardrum\\datasets\\alpha_composites_2_thr_multi_rfn_v4_aug\\'
dataset = datasets.ImageFolder(root, transform=data_transform)
train_size = int(0.85 * len(dataset))
val_size = len(dataset) - train_size
train_dataset, val_dataset = torch.utils.data.random_split(dataset, [train_size, val_size])

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True, num_workers=4)
val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False, num_workers=4)

# Define model
model = models.inception_v3(pretrained=True)
model.fc = nn.Sequential(
    nn.Linear(2048, len(dataset.classes)),
    nn.Softmax(dim=1)
)
model = model.to(device)

# Define loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.SGD(model.parameters(), lr=3e-4)

# Training loop
num_epochs = 100
for epoch in range(num_epochs):
    model.train()
    for inputs, labels in train_loader:
        inputs, labels = inputs.to(device), labels.to(device)

        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

    # Validation loop
    model.eval()
    with torch.no_grad():
        for inputs, labels in val_loader:
            inputs, labels = inputs.to(device), labels.to(device)

            outputs = model(inputs)
            _, predicted = torch.max(outputs, 1)

    # Calculate validation accuracy and confusion matrix
    # ... (you can use scikit-learn's confusion_matrix and accuracy_score)

# Save the model and other results
# ... (you can use torch.save for the model and other appropriate functions)