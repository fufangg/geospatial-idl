function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;========================================
pro plot_hovmoller_occci
;========================================
!P.position=[0.23,0.17,0.96,0.9]
!p.background='ffffff'x
!p.color=0
!p.font=1
;========================================
xsize=720
ysize=2000
;========================================
loadct,33,/silent
tvlct,r,g,b,/get
rgb1=(long(r) or ishft(long(g),8) or ishft(long(b),16))
rgb2=[[[rgb1 and 'ff'x]],[[ishft(rgb1 and 'ff00'x,-8)]],[[ishft(rgb1 and 'ff0000'x,-16)]]]
bar_length=fix(xsize*0.7)
rgb3=byte(congrid(rgb2,bar_length,15,3))
;========================================
lonmin_cut=106
lonmax_cut=107
;========================================
grid_interval=0.041671753  
;========================================
path_input3='E:\Data Ind V2\Olah\CHL\Indonesia_V2\Hovmuler\SST_2.sav'
restore,path_input3
data=dataset
;stop
;========================================
jul=data[0,*]
sst=data[1:*,*]
;stop
;========================================
juldate2=transpose(jul)
;stop
;========================================
dimens=size(sst,/dim)
widht=dimens[0]
;stop
;========================================
lon=lonmin_cut+findgen(round(widht))*grid_interval
;stop
;========================================
xrange1=[lonmin_cut,lonmax_cut]
;========================================
;date_label=label_date(date_format=['%M','%Y'])
date_label=label_date(date_format=['%Y'])
;========================================
year_start=2003
month_start=1
day_start=1

year_end=2019
month_end=12
day_end=31

jday_start = julday ( month_start,day_start, year_start,0.0,0.0,0.0)
jday_end = julday ( month_end,day_end, year_end, 23.0,59.0,0.0)
;stop
yrange1 = [jday_start,jday_end]
;========================================
y1=jul
x1=lon
;========================================
color_array=['000000'x, 'ff0000'x,'00ff00'x,'0099ff'x,'0000ff'x,'990000'x,'009966'x, '7f7f7f'x,'db70db'x, 'ffa300'x]
;========================================
window,0,xsize=xsize,ysize=ysize
;========================================
thick = 2.5
;========================================
A = findgen(32)*(!pi*2/32.0)
usersym,cos(A),sin(A),/fill
PLOT,x1,y1,/nodata,ystyle=4,$
    xthick=2.5, $
    xrange=xrange1,$
    XTICKinterval= 1, $
    xticklen=0.05,$
    charsize=2.5, $
    charthick=2.5, $
    font = -1
;stop
    axis,yaxis=0,yrange=yrange1,/save, $
    ythick=2.5, $
;    yTICKFORMAT = ['LABEL_DATE','LABEL_DATE'], $
;    yTICKUNITS = ['months','years'], $
    yTICKFORMAT = ['LABEL_DATE'], $
    yTICKUNITS = ['years'], $
    yTICKinterval= 1,$
    charsize=2.5, $
    charthick=2.5, $
    font = -1
;stop
max_value=2
min_value=0
;========================================
level_interval = 0.01
;========================================
numlevel=fix((max_value-min_value)/level_interval+1)
col=lonarr(numlevel)

for c=0,numlevel-1 do begin
cc=byte(c*level_interval/(max_value-min_value)*255)
col[c]=true2lon(rgb2[cc,0,*])
endfor
;========================================
levels=findgen(numlevel)*level_interval+min_value
;========================================
;stop
idx_low = where (sst le min_value,count_min)
if count_min gt 0 then sst[idx_low]=min_value

idx_high = where (sst ge max_value and sst lt 900,count_max)
if count_max gt 0 then sst[idx_high]=max_value
;========================================
contour,sst,lon,juldate2,/overplot, $
       max_value=max_value, $
       min_value=min_value, $
       levels=levels, $
       /cell_fill, $
       font=1,$
       c_colors=col[indgen(numlevel)]
;stop
;========================================
tv,rgb3, tr=3,0.16,0.08, /normal
;stop
;========================================
num_interval=0.4
;========================================
for w=0,num_interval do begin

index_value=w*(max_value-min_value)/num_interval+min_value
index_plot=string(index_value,format='(F6.1)')
x_position=0.15+0.7/num_interval*w
y_position=0.03
xyouts,x_position,y_position,index_plot, charsize=3.0, charthick=3.0, font=1,/normal,$
alignment=0.5

endfor
stop
;========================================
;title2= 'Sea Surface Temperature'
;XYOUTs,0.5,0.95,title2,/normal,alignment=0.5,charsize=3.5,charthick=3.0,font=1;,color=255

ws_unit='(mg/m!u3!n)'
XYOUTs,0.99,0.03,ws_unit,/normal,alignment=0.9,charsize=2.5,charthick=1.5,font=1,color='000000'xl
;========================================
;stop
file_mkdir,'E:\Data Ind V2\Hasil\CHL\Indonesia_V2\Hovmuler
path_output='E:\Data Ind V2\Hasil\CHL\Indonesia_V2\Hovmuler\SCHL.png'
T=TVRD(channel=0,true=1,order=0)
write_png,path_output,T
;========================================
print, 'finish'
stop
end
