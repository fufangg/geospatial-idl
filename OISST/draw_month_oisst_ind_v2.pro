function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;==========================================
pro draw_month_oisst_ind_v2
;==========================================
!p.background='ffffff'x
!p.color=0
;==========================================
;!P.Region=[0.02,0.09,0.98,0.98]
;!P.Position=[0.07,0.07,0.95,0.95]
;!P.Position=[0.07,0.07,0.84,4.]
;!P.Position=[0.14,0.07,0.84,4.]
;!P.Position=[0.1,0.07,0.89,0.98] 
!P.Position=[0.1,0.07,0.89,1.] ;ini yang dipakai untuk besar kecilnya tampilan peta. angka pertama semakin kecil maka kotak geser kekiri. kedua, nilai semakin besar maka kotak akan ke atas. ketiga, nilai semakin besar 
;==========================================
loadct,33,/silent
tvlct,r,g,b,/get
rgb1=(long(r) or ishft(long(g),8) or ishft(long(b),16))
rgb2=[[[rgb1 and 'ff'x]],[[ishft(rgb1 and 'ff00'x,-8)]],[[ishft(rgb1 and 'ff0000'x,-16)]]]
;==========================================
xsize=1000
ysize=720
;==========================================
bar_length=fix(xsize*0.7)
rgb3=byte(congrid(rgb2,bar_length,15,3))
;stop
;============data coverage=================
;==============indonesia===================
latmin=-15 
latmax=10
lonmin=90
lonmax=140

image_width = 570     
image_height = 286
;===========image coverage=================
;==============indonesia===================
latmin_plot = -8
latmax_plot = -3
lonmin_plot= 123
lonmax_plot= 131
;==========================================
;===========spatial_resolution=============
grid_interval=0.087890625
;stop
;===============Looping year==============
start_year=2003
;start_year=2020
end_year=2020
for year=start_year,end_year do begin
  year_st=strtrim(string(year,format='(I4.4)'),2)
;===============Looping Month==============
start_month=1
end_month=12
for month=start_month,end_month do begin
month_st=strtrim(string(month,format='(I2.2)'),2)
;===============Data Input=================
path_input='${filepath}\'+year_st+'\sst'+year_st+month_st+'.sav
;===============Open Data==================
restore,path_input
data=data_map;-273.15
idx= where(data lt 500.)
;stop
;==========================================
window,0,xsize=xsize,ysize=ysize,/pixmap
;stop
lon2=lonmin+findgen(round(image_width))*grid_interval
lat2=latmin+findgen(round(image_height))*grid_interval
;stop
;==========================================
map_set,0,180,limit=[latmin_plot,lonmin_plot,latmax_plot,lonmax_plot],/iso
;==========================================
;stop
max_value=30.5
min_value=25.5
index_max=where((data gt max_value)and(data lt 500),count_max)
if (count_max ne 0)then data[index_max]=max_value

index_min=where(data lt min_value,count_min)
if (count_min ne 0)then data[index_min]=min_value
;stop
;=========================================
;==============Color Interval=============
level_interval=0.05
numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)
;stop
for e=0,numlevel-1 do begin
  cc=byte(e*level_interval/(max_value-min_value)*255)
  col[e]=true2lon(rgb2[cc,0,*])
endfor
levels=findgen(numlevel)*level_interval+min_value
;stop
;=========================================
contour,data,lon2,lat2,/overplot, $
  max_value=max_value, $
  min_value=min_value, $
  levels=levels, $
  /cell_fill, $
  font=1, $
 c_colors=col[indgen(numlevel)]
;stop
;=================================================================
map_continents,/coasts,mlinethick=2.5,/hires
;stop
;map_grid,/box_axes,londel=1., latdel=1.,charsize=3.5,charthick=3
map_grid,/box_axes,londel=1., latdel=1.,charsize=3.5,charthick=3 ;dipakai untuk banyak kotak, besar kecilnya kotak, serta besar kecil tebalnya ukuran angka latitude dan longitude
;stop
;================================================================
tv,rgb3,tr=3,0.15,0.1,/normal
;stop
;================================================================
;=============interval value in colorbar=========================
interval_measure=1
num_interval=round((max_value-min_value)/interval_measure)
for w=0,num_interval do begin
  index_value=w*(max_value-min_value)/float(num_interval)+min_value
  ;index_plot=string(index_value,format='(F5.1)')
  index_plot=string(index_value,format='(F5.1)')
  x_position=0.15+0.7/num_interval*w ;angka pertama menunjukkan semakin besar nilai maka akan geser ke kanan tanpa mempengaruhi interval angka, angka kedua menunjukkan semakin besar nilai maka interval semakin lebar dan angka akan ke kanan
  y_position=0.05 ;semakin besar nilainya, angka di keterangan warna akan ke atas (masuk ke grid)
  ;xyouts,x_position,y_position,index_plot,charsize=2.5,charthick=2.5,font=1,/normal,alignment=0.5
  xyouts,x_position,y_position,index_plot,charsize=3.5,charthick=3.,font=1,/normal,alignment=0.5 ;(kepakai), buat ukuran angka di bawah keterangan warna
endfor
;stop
;================Layout==================
;title2='SST '+month_st
;XYOUTs,0.5,0.9,title2,/normal,alignment=0.5,charsize=3.5,charthick=1.5,font=1;,color=255
;XYOUTs,0.5,0.19,'Longitude (!U0!NE)',/normal,alignment=0.5,charsize=3.,charthick=2.5,font=1, color='000000'xl
;XYOUTs,0.03,0.5,'Latitude (!U0!NN)',/normal,alignment=0.5,charsize=3.,charthick=2.5,font=1, orientation=90, color='000000'xl
unit_st='(!U0!NC)'
XYOUTs,0.93,0.05,unit_st,/normal,alignment=0.5,charsize=3.,charthick=2.0,font=1;,color=255

;stop
;=============Save Data==================
file_mkdir, '${filepath}\'+year_st+'
path_output ='${filepath}\'+year_st+'\sst_'+year_st+month_st+'.png'
T=TVRD(channel=0,true=1,order=0)
write_png,path_output,T
;=================================================
endfor
endfor
print,'finish'
;stop
!P.Region=0
!P.Position=0
end