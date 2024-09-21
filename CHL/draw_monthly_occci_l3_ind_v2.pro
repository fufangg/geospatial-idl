function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;-----------------------------default------------------------------------------

;==============================
pro draw_monthly_occci_l3_ind_v2
;==============================
;==========================================
!p.background='ffffff'x
!p.color=0
;=====================================
;!P.Region=[0.02,0.09,0.98,0.98]
!P.Position=[0.07,0.07,0.95,0.95]
;======================colorbar==========================
loadct,33,/silent
tvlct,r,g,b,/get
rgb1=(long(r) or ishft(long(g),8) or ishft(long(b),16))
rgb2=[[[rgb1 and 'ff'x]],[[ishft(rgb1 and 'ff00'x,-8)]],[[ishft(rgb1 and 'ff0000'x,-16)]]]

;*********************************************************************
xsize=1000
ysize=720

;xsize=600
;ysize=800
bar_length=fix(xsize*0.7)
rgb3=byte(congrid(rgb2,bar_length,15,3))

;=================SELAT MALAKA====================
grid_interval=0.041671753                                  

latmin=-35
latmax=20
lonmin=70
lonmax=150

image_width = round((lonmax-lonmin)/grid_interval+1)              
image_height = round((latmax-latmin)/grid_interval+1)   

latmin_cut=1
latmax_cut=6
lonmin_cut=95
lonmax_cut=105

;stop
;-------image_plot-------
;-------image_plot-------
;stop
latmin_plot = latmin_cut
latmax_plot = latmax_cut
lonmin_plot = lonmin_cut
lonmax_plot = lonmax_cut
;bali ntb
;latmin_plot = -9.0
;latmax_plot = -6.5
;lonmin_plot = 114
;lonmax_plot = 118
;
;ntt
;latmin_plot = -9.5
;latmax_plot = -5.5
;lonmin_plot = 117.5
;lonmin_plot = 114
;lonmax_plot = 127.5

;maluku
;latmin_plot = -4
;latmax_plot = -1
;lonmin_plot = 127.
;lonmax_plot = 132

;;makassar
;latmin_plot = -6
;latmax_plot = -3.5
;lonmin_plot = 117.
;lonmax_plot = 120

;;lampung
;latmin_plot = -6
;latmax_plot = -3.
;lonmin_plot = 105.
;lonmax_plot = 108

;;;kangean
;latmin_plot = -7.25
;latmax_plot = -6.25
;lonmin_plot = 115.
;lonmax_plot = 117
;

;;*****************************************************************************************************************
;stop
;===============Looping year==============
start_year=2003
end_year=2020
for year=start_year,end_year do begin
  year_st=strtrim(string(year,format='(I4.4)'),2)
;-------------------loop_for_month-------------------------90_ID
start_month=1
end_month=12

for month=start_month,end_month do begin

month_st=strtrim(string(month,format='(I2.2)'),2)
;======================================================

;***********************************************************************************
;
path_input='${filepath}\'+year_st+'\'+year_st+month_st+'.sav
datanc=findfile(path_input,count=num_ncf)
;stop
for inc=0,num_ncf-1 do begin
print,path_input
restore, datanc[inc]
sst_map=data_map
;stop
lon_beg = lonmin_cut
lon_end = lonmax_cut
lat_beg = latmin_cut
lat_end = latmax_cut
a = round ((lon_beg-lonmin)/grid_interval)
b = round ((lon_end-lonmin)/grid_interval)
c = round ((lat_beg-latmin)/grid_interval)
d = round ((lat_end-latmin)/grid_interval)


window,0,xsize=xsize,ysize=ysize;,/pixmap
;stop
lon2=lonmin+findgen(round(image_width))*grid_interval
lat2=latmin+findgen(round(image_height))*grid_interval
map_set,0,180,limit=[latmin_plot,lonmin_plot,latmax_plot,lonmax_plot],/iso
;top
;-----------------------------max min value -----------------------------------
max_value=3;maxmax
min_value=0.

index_max=where((sst_map gt max_value)and(sst_map lt 100),count_max)
if (count_max ne 0)then sst_map[index_max]=max_value

index_min=where(sst_map lt min_value,count_min)
if (count_min ne 0)then sst_map[index_min]=min_value
;**************************************************************************

;-----------------------------interval contour---------------------------
level_interval=0.05


numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)

for e=0,numlevel-1 do begin
  cc=byte(e*level_interval/(max_value-min_value)*255)
  col[e]=true2lon(rgb2[cc,0,*])
endfor

levels=findgen(numlevel)*level_interval+min_value
;stop
;------------SST_contour--------------
contour,sst_map,lon2,lat2,/overplot, $
       max_value=max_value, $
       min_value=min_value, $
       levels=levels, $
       /cell_fill, $
       font=1,$
       c_colors=col[indgen(numlevel)]
;       levels =[27,27.5,28,28.5,29,29.5]
;c_labels=[1,0,1,0,1,0]

   ;stop
;contour,sst_monthly_clim,lon2,lat2,levels=levels,c_labels=c_labels,c_charthick=1.5,c_charsize=1.5,thick=2.,color ='7f7f7f'xl,/overplot
;----contour_interval----
;level_interval = 1
;stop
;===================================================================
map_continents,/coasts,mlinethick = 2, /hires;,/fill ;, color ='7f7f7f'xl,fill_continents=1
map_grid,/box_axes, londel=1, latdel=1,charsize=3.5,charthick=3
;my_gtopo30plot_max1000_westpac5,latmin_plot,lonmin_plot,latmax_plot,lonmax_plot,xsize,charsize=2.,symsize=1,colorbar=1

;;===================================
tv,rgb3, tr=3,0.15,0.1,/normal
;-------------------------------------interval value in color bar----------------------
interval_measure=0.5

num_interval=round((max_value-min_value)/interval_measure)
for w=0,num_interval do begin

  index_value=w*(max_value-min_value)/float(num_interval)+min_value
  index_plot=string(index_value,format='(F5.1)')
  x_position=0.14+0.7/num_interval*w
  y_position=0.05
  xyouts,x_position,y_position,index_plot,charsize=3.5,charthick=3,font=1,/normal,alignment=0.5

endfor
;===========================

;title2='CHL '+month_st
;XYOUTs,0.5,0.98,title2,/normal,alignment=0.5,charsize=2,charthick=3,font=1;,color=255
;XYOUTs,0.5,0.13,'Longitude (!U0!NE)',/normal,alignment=0.5,charsize=1.5,charthick=3,font=1, color='000000'xl
;XYOUTs,0.02,0.5,'Latitude (!U0!NN)',/normal,alignment=0.5,charsize=1.5,charthick=3,font=1, orientation=90, color='000000'xl
unit_st='(mg/m!u-3!n)'
XYOUTs,0.945,0.05,unit_st,/normal,alignment=0.5,charsize=2,charthick=2,font=1 ;,color=255
;stop
;=============================================================================
file_mkdir, '${filepath}\'+year_st+'
path_output='${filepath}\'+year_st+'\'+year_st+month_st+'.png'

;==================================================
T=TVRD(channel=0,true=1,order=0)
write_png,path_output,T
;=========================
;stop
;*********************************************************************************
endfor
endfor
endfor  ;-------------------end_of_loop_of_month-----90_ID-----------
;stop

print,'finish'
;stop

!P.Region=0
!P.Position=0

end

