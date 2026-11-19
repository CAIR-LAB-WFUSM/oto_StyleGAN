# data tool

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/Ziyu/tumorbud/tumorbud_dataset/toydata --dest=datasets/tb_toy.zip

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/images --dest=dataset/eardrum.zip

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/images_for_GAN_v2 --dest=dataset/eardrum_datasetgan_v2.zip

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/effusion_GAN --dest=dataset/effusion_gan.zip

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Abnormal_GAN --dest=dataset/abnormal_gan.zip

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Tympanosclerosis_Gan --dest=dataset/tympano_gan.zip

python dataset_tool.py --source=/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Perforation_Gan --dest=dataset/perforation_gan.zip


# stylegan2 training
python train.py --outdir=training-runs --data=datasets/tb_toy.zip --gpus=1 --cfg=paper512 --mirror=1 --snap=25

python train.py --outdir=training-runs --data=datasets/tb_train.zip --gpus=1 --cfg=paper512 --mirror=1 --snap=25



python train.py --outdir=training-runs --data=datasets/cam16dataset.zip \\
     --cfg=paper512 --gpus=1 --mirror=1 --aug=noaug