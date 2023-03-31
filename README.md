# Nondominated-Solution-Based Multi-Objective Greedy Sensor Selection for Optimal Design of Experiments
<!-- This repository contains Matlab (R2020b) code to reproduce results for the Determinant-based Fast Greedy Sensor Selection Algorithm.


Due to GitHub file size limitations, a dataset is linked online:[NOAA Optimum Interpolation (OI) Sea Surface Temperature (SST) V2](https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.html)
- sst.wkmean.1990-present.nc
- lsmask.nc


**Ocean sea surface temperature data is provided by NOAA.
NOAA_OI_SST_V2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their Web site at https://www.esrl.noaa.gov/psd/.**

## License
[MIT-License](https://github.com/YujiSaitoJapan/Determinant-based-Fast-Greedy-Sensor-Selection-Algorithm/blob/add-license-1/LICENSE)

## Code  
---
### Main program  
- P_greedy_noise_demo.m  

### Function  
#### Preprocessing  
- F_pre_read_NOAA_SST.m  
- F_pre_SVD_NOAA_SST.m  
- F_pre_truncatedSVD.m  

#### Sensor selection  
- F_sensor_random.m
- F_sensor_DG.m  
  - F_sensor_DG_r.m  
  - F_sensor_DG_p.m
- F_sensor_DGCN.m  
  - F_sensor_DGCN_r.m  
  - F_sensor_DGCN_p.m
- F_sensor_BDG.m  


#### Calculation
- F_calc_det.m  
- F_calc_sensormatrix.  
- F_calc_error.m  
  - F_calc_reconst.m  
  - F_calc_reconst_error.m  

#### Data organization  
- F_data_ave1.m  
- F_data_ave2.m  
- F_data_ave3.m  
- F_data_arrange.m
- F_data_normalize.m  

#### Mapping
- F_map_original.m  
	- F_map_videowriter.m  
		- F_map_plot_sensors_forvideo.m  
- F_map_reconst.m  
	- F_map_plot_sensors.m  
- F_fig_SST_sensors_color_compare.m  
       -->
## License
[MIT-License](https://github.com/Aerodynamics-Lab/Nondominated-Solution-Based-Multi-Objective-Greedy-Sensor-Selection-for-Optimal-Design-of-Experiment/blob/main/LICENSE)
## How to cite
If you use the codes in your work, please cite the software itself and relevant paper.
### General software reference:
```bibtex
@misc{nakai2023github,
      author = {Nakai, Kumi},
      title = {Nondominated-Solution-Based Multi-Objective Greedy Sensor Selection for Optimal Design of Experiments},
      howpublished = {Available online},
      year = {2021},
      url = {https://github.com/Aerodynamics-Lab/Nondominated-Solution-Based-Multi-Objective-Greedy-Sensor-Selection-for-Optimal-Design-of-Experiment}
}
```
### Relevent paper reference:
```bibtex
@ARTICLE{9969932,
  author={Nakai, Kumi and Sasaki, Yasuo and Nagata, Takayuki and Yamada, Keigo and Saito, Yuji and Nonomura, Taku},
  journal={IEEE Transactions on Signal Processing}, 
  title={Nondominated-Solution-Based Multi-Objective Greedy Sensor Selection for Optimal Design of Experiments}, 
  year={2022},
  volume={70},
  number={},
  pages={5694-5707},
  doi={10.1109/TSP.2022.3224643}
}
```
## Author
---
Kumi Nakai  
[Research Institute for Energy Conservation](https://unit.aist.go.jp/ieco/en/index.html)  
Department of Energy and Environment, National Institute of Advanced Industrial Science and Technology (AIST)  
Tsukuba, JAPAN

E-mail: kumi.nakai@aist.go.jp