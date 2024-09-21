pro compile_climatology_oisst_Indonesia_V2                            
TIC
;====================================================
grid_interval= 0.087890625

latmin=-8 
latmax=-3
lonmin=123
lonmax=131

image_width = 570     
image_height = 286
;stop
;==================month===============
start_month=1
end_month=12
for month= start_month, end_month do begin
month_st = strtrim(string(month,format='(I2.2)'),2)
;====================================================
SST_monthly_map = fltarr(image_width,image_height)
num_monthly_map = fltarr(image_width,image_height)
num=0.
;==============year===================
start_year=2003
end_year=2019

for year= start_year, end_year do begin
year_st = strtrim(string(year,format='(I4.4)'),2)
;=============masukin data==============
path_input='${filepath}\sst'+month_st+'.sav
datanc= findfile(path_input,count=num_files)   
;stop
if num_files gt 0 then begin
for inc=0,num_files-1 do begin

restore,datanc[inc]
indx_sst = where (data_map ne 999., count_index)    
;stop
;==================================================

SST_monthly_map[indx_sst] = SST_monthly_map[indx_sst] + data_map[indx_sst]  ; Data yang kurang dari 100 masuk perhitungan
num_monthly_map[indx_sst] = num_monthly_map[indx_sst] + 1
num=num+1

;stop
endfor
endif
endfor
;===================AVERAGING (default)=================
indx_sst_monthly=where(num_monthly_map gt 0,count_indx_sst_monthly)
data_map=fltarr(image_width,image_height)+999.
;stop
data_map[indx_sst_monthly]=SST_monthly_map[indx_sst_monthly]/float(num_monthly_map[indx_sst_monthly]) ;float = numerik desimal
;stop
file_mkdir, '${filepath}'
path_output='${filepath}\sst'+month_st+'.sav
save,data_map,filename=path_output
print,month
endfor
;stop
print, 'finish'
TOC
;stop
end
