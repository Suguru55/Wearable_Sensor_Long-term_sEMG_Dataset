# Wearable_Sensor_Long-term_sEMG_Dataset

I'm submitting this study to XXX<br />
Now, we uploaded only S01 data, but will upload all data after paper acceptance.<br /><br />

You can see very simple online processing for controlling 3D graphics using by this dataset from <a href="https://drive.google.com/file/d/1X7LKOcaBsfopQSHAjnUlRBB9HMoG0Lmt/view?usp=sharing" target="_blank">here (online_processing)</a>.<br />
In addition, the effect of reattachment is <a href="https://drive.google.com/open?id=1JcXjvT0ijIlekM66pkRsCLoMZKOBFq7v" target="_blank">here (indiscriminable_reattachment)</a>.<br />

__\<Description\>__<br />
After changing your directories in set_config.m and downloading getxxfeat.m, you can use this codes.<br />
This project has four folders:<br />
1. hand motions<br />
    8 short movies for each fundamental forearm motion

2. data<br />
   - 30-days EMG data from 5 subjects
   - csv files (each data has 1.5-s information)
   - D means day
   - M means the motion label (e.g., M1 means resting state and M2 means wrist flexion)
   - T means the number of trials

3. code<br />
   this folder has one main m.file named main_script that uses:<br />
   - set_config<br />
   - preprocessing<br />
        - extract_feature<br />
        you can get the following m.files from <a href="http://www.sce.carleton.ca/faculty/chan/index.php?page=matlab" target="_blank">here</a><br />
            - getrmsfeat<br />
            - getmavfeat<br />
            - getzcfeat<br />
            - getsscfeat<br />
            - getwlfeat<br />
            - getarfeat<br />
    - intraday<br />
        - plot_figure3<br />
        - plot_figure4_and_figure5<br />
    - interday<br />
        - labeling<br />
        - interday_recog<br />
        - plot_figure6<br />
    - interday_sub<br />
        - plot_figure7<br />
        
4. resuts <br />
   this folder will store all results (but this main script requires about 10GB for saving result data, please take care before using it)

__\<Environments\>__<br />
MATLAB R2018b<br />
 1. Signal Processing Toolbox
 2. Statics and Machine Learning Toolbox
