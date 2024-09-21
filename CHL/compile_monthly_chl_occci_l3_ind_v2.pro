pro compile_monthly_chl_occci_l3_ind_v2                    
TIC
grid_interval=0.041671753                                  

latmin=-35
latmax=20
lonmin=70
lonmax=150

image_width = round((lonmax-lonmin)/grid_interval+1)              
image_height = round((latmax-latmin)/grid_interval+1)   

;stop

;==============year===================
start_year= ;example=2003
end_year= ;example=2019
for year= start_year, end_year do begin
year_st = strtrim(string(year,format='(I4.4)'),2)
;==================month===============
start_month=1
end_month=12
for month= start_month, end_month do begin
month_st = strtrim(string(month,format='(I2.2)'),2)

;====================================================
sst_monthly_map = fltarr(image_width,image_height)
num_monthly_map1 = fltarr(image_width,image_height)
num=0.
;=============input data==============
path_input='${filepath}\'+year_st+'\'+year_st+month_st+'*.sav
datanc= findfile(path_input,count=num_files)                                ; find Data / File
;stop
if num_files gt 0 then begin
for inc=0,num_files-1 do begin
restore,datanc[inc]
;stop
indx_tcc = where (data_map ge 0., count_index)              
;stop
;==================================================
sst_monthly_map[indx_tcc] = sst_monthly_map[indx_tcc] + data_map[indx_tcc]  
num_monthly_map1[indx_tcc] = num_monthly_map1[indx_tcc] + 1
;stop
endfor
;===================AVERAGING (default)=================
indx_tcc_monthly=where(num_monthly_map1 gt 0)
data_map=fltarr(image_width,image_height)+999.
data_map[indx_tcc_monthly]=sst_monthly_map[indx_tcc_monthly]/float(num_monthly_map1[indx_tcc_monthly])
;stop
file_mkdir, '${filepath}\'+year_st+'\
path_output='${filepath}\'+year_st+'\'+year_st+month_st+'.sav
save,data_map,filename=path_output

print,year,month
endif
endfor
endfor
;stop
print, 'finish'
TOC
;stop
end
