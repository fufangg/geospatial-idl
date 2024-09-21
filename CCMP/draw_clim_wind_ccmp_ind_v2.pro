function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;-----------------------------default------------------------------------------

;==============================
pro draw_clim_wind_ccmp_ind_v2
;==============================
;==========================================
!p.background='ffffff'x
!p.color=0
;=====================================
;!P.Region=[0.02,0.09,0.98,0.98]
;!P.Position=[0.07,0.07,0.95,0.95]
!P.Position=[0.1,0.07,0.89,1.]
;======================colorbar==========================
loadct,33,/silent
tvlct,r,g,b,/get
rgb1=(long(r) or ishft(long(g),8) or ishft(long(b),16))
rgb2=[[[rgb1 and 'ff'x]],[[ishft(rgb1 and 'ff00'x,-8)]],[[ishft(rgb1 and 'ff0000'x,-16)]]]

;*********************************************************************
;======================mapsize===========================
xsize=1000
ysize=720



;xsize=600
;ysize=800
bar_length=fix(xsize*0.7)
rgb3=byte(congrid(rgb2,bar_length,15,3))

;=================Example: Laut Jawa====================
latmin=-15
lonmin=91

;latmin=-8
;lonmin=123
;===============spatial resolution=============
grid_interval= 0.25
;grid_interval=0.041671753
;==============data dimension==================
image_width = 201
Image_height = 101
;STOP
;-------image_plot-------
lon=lonmin+findgen(round(image_width))*grid_interval
lat=latmin+findgen(round(image_height))*grid_interval

lat_map=fltarr(image_width,image_height)
for i=0,image_width-1 do begin
  lat_map[i,*]=lat
  ;stop
endfor

lon_map=fltarr(image_width,image_height)
for i=0,image_height-1 do begin
  lon_map[*,i]=lon
  ;stop
endfor
;-------image_plot-------
;stop
;Sulawesi
latmin_cut=-8
latmax_cut=-3
lonmin_cut=123
lonmax_cut=131

latmin_plot = latmin_cut
latmax_plot = latmax_cut
lonmin_plot = lonmin_cut
lonmax_plot = lonmax_cut

;==================month===============
start_month=12
end_month=12
for month= start_month, end_month do begin
month_st = strtrim(string(month,format='(I2.2)'),2)

;======================================================

;***********************************************************************************

;path_input='H:\data_analysis\climatology\gsmap\indonesia\rain_'+month_st+'.sav';---------------------
path_input= ;'${filepath}.sav'
datanc=findfile(path_input,count=num_ncf)
;stop
for inc=0,num_ncf-1 do begin
pos_filename3=strpos(datanc[inc],'\uwnd'+month_st)
filename3=strtrim(strmid(datanc[inc],pos_filename3+5,16),2)
print, filename3  
;stop
;print,path_input
restore, datanc[inc]
u_map=monthly_map_u
MAP_U=u_map
;restore,'E:\DATA IND V2\Olah\CCMP\Indonesia_V2\vwnd\Climatology\vwnd'+month_st+'.sav'
restore, '${filepath}.sav'
v_map=monthly_map_v
MAP_V=v_map
ws = sqrt(map_u^2+map_v^2)
SST_map=ws
;stop
window,0,xsize=xsize,ysize=ysize;,/pixmap
;stop
lon2=lonmin+findgen(round(image_width))*grid_interval
lat2=latmin+findgen(round(image_height))*grid_interval
map_set,0,180,limit=[latmin_plot,lonmin_plot,latmax_plot,lonmax_plot],/iso
;top
;-----------------------------max min value -----------------------------------
max_value=10;maxmax
min_value=0

index_max=where((sst_map gt max_value)and(sst_map lt 100),count_max)
if (count_max ne 0)then sst_map[index_max]=max_value
;
index_min=where(sst_map lt min_value,count_min)
if (count_min ne 0)then sst_map[index_min]=min_value
;**************************************************************************

;-----------------------------interval contour---------------------------
level_interval=0.005


numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)

for e=0,numlevel-1 do begin
  cc=byte(e*level_interval/(max_value-min_value)*255)
  col[e]=true2lon(rgb2[cc,0,*])
endfor

levels=findgen(numlevel)*level_interval+min_value
;stop
;------------SST_contour--------------
;contour,sst_map,lon2,lat2,/overplot, $
;       max_value=max_value, $
;       min_value=min_value, $
;       levels=levels, $
;       /cell_fill, $
;       font=1,$
;       c_colors=col[indgen(numlevel)]
;       levels =[0.4,0.5,0.6,0.7,0.8,0.9]
;c_labels=[1,0,1,0,1,0]

  ; stop
;contour,sst_map,lon2,lat2,levels=levels,c_labels=c_labels,c_charthick=1.5,c_charsize=1.5,thick=2.,color ='7f7f7f'xl,/overplot
;----contour_interval----
;level_interval = 1
;stop
;===================================================================

;my_gtopo30plot_max1000_westpac2,latmin_plot,lonmin_plot,latmax_plot,lonmax_plot,xsize,charsize=2.,symsize=1,colorbar=1

;;===================================
tv,rgb3, tr=3,0.15,0.1,/normal
;-------------------------------------interval value in color bar----------------------
interval_measure=2

num_interval=round((max_value-min_value)/interval_measure)
for w=0,num_interval do begin

  index_value=w*(max_value-min_value)/float(num_interval)+min_value
  index_plot=string(index_value,format='(F7.1)')
  x_position=0.14+0.7/num_interval*w
  y_position=0.05
  xyouts,x_position,y_position,index_plot,charsize=3.5,charthick=3,font=1,/normal,alignment=0.5

endfor
;===========================

;title2='Wind '+month_st+'
;XYOUTs,0.5,0.98,title2,/normal,alignment=0.5,charsize=2,charthick=3,font=1;,color=255
;XYOUTs,0.5,0.13,'Longitude (!U0!NE)',/normal,alignment=0.5,charsize=1.5,charthick=3,font=1, color='000000'xl
;XYOUTs,0.02,0.5,'Latitude (!U0!NN)',/normal,alignment=0.5,charsize=1.5,charthick=3,font=1, orientation=90, color='000000'xl
unit_st='(m/s)'
XYOUTs,0.945,0.05,unit_st,/normal,alignment=0.5,charsize=2.5,charthick=3.0,font=1 ;,color=255
;stop
;==================================================
sampling=2
width2=round(image_width/sampling)
height2=round(image_height/sampling)
map_u=congrid(map_u,width2,height2)
map_v=congrid(map_v,width2,height2)
lon_map=congrid(lon_map,width2,height2)
lat_map=congrid(lat_map,width2,height2)

;u_array=reform(map_u,width2*height2)
;v_array=reform(map_v,width2*height2)
;lat_array=reform(lat_map,width2*height2)
;lon_array=reform(lon_map,width2*height2)
IDX11=where(map_u gt -10000)

u_array=map_u[IDX11]
v_array=map_v[IDX11]
lat_array=lat_map[idx11]
lon_array=lon_map[idx11]
;stop
;u_array=reform(map_u,widht*height)
;v_array=reform(map_v,widht*height)
;lat_array=reform(lat_map,widht*height)
;lon_array=reform(lon_map,widht*height)

inn= where(u_array lt 10 ,count_in)
;stop
if count_in ne 0 then begin
  u_array= u_array[inn]
  v_array= v_array[inn]
  lat_array= lat_array[inn]
  lon_array= lon_array[inn]
endif
;stop
;===========================================================================
index=where((lat_array ge latmin_plot)and(lat_array le latmax_plot)and $
  (lon_array ge lonmin_plot)and(lon_array le lonmax_plot),count)

u_array=u_array[index]
v_array=v_array[index]
lat_array=lat_array[index]
lon_array=lon_array[index]
;my_gtopo30plot_max1000_westpac6,latmin_plot,lonmin_plot,latmax_plot,lonmax_plot,xsize,charsize=2.5,symsize=0.5,colorbar=1
my_varrows,u_array,v_array,lon_array,lat_array,rgb2, Length = 1.0, Title = title, $
  Color='666666'x,Thick=1.5,mag_ref=max_value, $
  min_value=min_value;,/monotone


map_continents,/coasts,mlinethick = 2, /hires;,/fill ;, color ='7f7f7f'xl,fill_continents=1
map_grid,/box_axes, londel=1, latdel=1,charsize=3.5,charthick=3
;stop
;=============================================================================
file_mkdir, 'E:\Data Ind V2\Hasil\CCMP\Climatology\
path_output='E:\Data Ind V2\Hasil\CCMP\Climatology\'+month_st+'.png'

;==================================================
T=TVRD(channel=0,true=1,order=0)
write_png,path_output,T
;=========================
;stop
;*********************************************************************************
endfor
endfor  ;-------------------end_of_loop_of_month-----90_ID-----------
;stop

print,'finish'
;stop

!P.Region=0
!P.Position=0

end

