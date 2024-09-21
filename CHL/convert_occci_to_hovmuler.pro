;==============================
pro convert_occci_to_hovmuler
;==============================
;========Area Coverage=========
latmin=-35
latmax=20
lonmin=70
lonmax=150
;==============================
;======Spatial Resolution======
grid_interval=0.041671753  
;==============================
;========Data Dimension========
widht=round((lonmax-lonmin)/grid_interval+1)
height=round((latmax-latmin)/grid_interval+1)
;stop
;==============================
;========Looping Year==========
start_year=2003
end_year=2019
count_msst=0
for year=start_year,end_year do begin
year_st=strtrim(string(year,format='(I4.4)'),2)
;========Looping Month=========
start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)
;========Julian Date===========
juldate =julday(month,1,year)
;==============================
;stop
;========Path Input============
path_input='E:\Data Ind V2\Olah\CHL\Indonesia_V2\Monthly\'+year_st+'\'+year_st+month_st+'.sav
datanc=findfile(path_input,count=num_ncf)
for inc=0,num_ncf-1 do begin
restore,datanc[inc]
sst_map=data_map;-273.15
;stop
;==============================
;=========Plot Area============
latmin_cut=-6.4
lonmin_cut=106
latmax_cut=-5.8
lonmax_cut=107

a = fix ((lonmin_cut-lonmin)/grid_interval)
b = fix ((lonmax_cut-lonmin)/grid_interval)
c = fix ((latmin_cut-latmin)/grid_interval)
d = fix ((latmax_cut-latmin)/grid_interval)
sst_map=sst_map[a:b,c:d]
;stop
;==============================
;======Processing Data=========
dimen=size(sst_map,/dim)
line=dimen[0]
col=dimen[0]
data=fltarr(col)
;stop
for x=0,col-1 do begin
test=sst_map[x,*]
idx_test=where(test lt 100., count_test)
if count_test gt 0 then begin
data[x]=mean(test[idx_test])
endif else begin
data[x]= 999.
endelse
endfor
;stop
;=========For Eksport==========
if(count_msst eq 0) then begin
dataset=[juldate,data]
endif else begin
dataset=[[dataset],[juldate,data]]
endelse
count_msst=count_msst+1

endfor
endfor
endfor
stop
;===============================
;===========Save Data===========
file_mkdir, 'E:\Data Ind V2\Olah\CHL\Indonesia_V2\Hovmuler\
path_output='E:\Data Ind V2\Olah\CHL\Indonesia_V2\Hovmuler\SST_2.sav'
save,dataset,filename=path_output

print,'finish'
;stop
end
