# train 512x512, tb images
python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/datasets/tb_shuffle_train.zip \
	--cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000 --resume ./training-runs/00006-stylegan2-tb_shuffle_train-gpus1-batch32-gamma5/network-snapshot-001200.pkl


python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/eardrum_datasetgan_v2.zip \
	--cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000 --resume ./training-runs/00006-stylegan2_eardrum_v2_train-gpus1-batch32-gamma5/


for the first run, I didn't give the --resume parameter, and the following

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/eardrum_datasetgan_v2.zip \\
	--cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000 --resume ./training-runs/00001-stylegan2_eardrum_v2_train-gpus1-batch32-gamma5

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/eardrum_adult.zip --cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000 --resume ./training-runs/00001-stylegan2_eardrum_v2_train-gpus1-batch32-gamma5

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/eardrum_adult.zip --cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000  -output is too large error

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/eardrum_adult.zip --cfg=stylegan2 --gpus=1 --batch=16 --gamma=5 --mirror=1 --kimg 5000 

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/normal_gan.zip --cfg=stylegan2 --gpus=1 --batch=16 --gamma=5 --mirror=1 --kimg 5000 

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/abnormal_gan.zip --cfg=stylegan2 --gpus=1 --batch=16 --gamma=5 --mirror=1 --kimg 5000 

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/effusion_gan.zip --cfg=stylegan2 --gpus=1 --batch=16 --gamma=5 --mirror=1 --kimg 5000 

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/tympano_gan.zip --cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000 

python train.py --outdir=./training-runs --cfg=stylegan2 --data=../stylegan2-ada-pytorch/dataset/perforation_gan.zip --cfg=stylegan2 --gpus=1 --batch=32 --gamma=5 --mirror=1 --kimg 5000 
