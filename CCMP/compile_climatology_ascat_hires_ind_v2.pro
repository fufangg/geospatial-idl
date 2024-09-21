function true2lon,rgb
;rgb is array of lonarr(3)
    return,(long(rgb[0]) or ishft(long(rgb[1]),8) or ishft(long(rgb[2]),16))
end
;-----------------------------default------------------------------------------

;==============================
pro compile_climatology_ascat_hires_ind_v2
;==============================
TIC
;-----------background_color------------
!p.background='ffffff'x ;---putih---
!p.color=0 ;---hitam---
;---------------------------------------
;----------window_region---------
!P.Region=[0.05,0.09,0.95,0.94]
;!P.Position=[0.1,0.07,0.89,1.]
;--------------------------------
;**************************************************************************************

image_width = 201
Image_height = 101

;image_width = 570
;Image_height = 286
;;*****************************************************************************************************************
;;----initial_condition_for_calculating_all_compilation---
;SST_monthly_map=fltarr(image_width,image_height)
;num_monthly_map=fltarr(image_width,image_height)
;==================================================
;======================================================

;-------------------loop_for_month-------------------------90_ID
start_month=1
end_month=12
for month=start_month,end_month do begin
  month_st=strtrim(string(month,format='(I2.2)'),2)

  ;;----initial_condition_for_calculating_monthly_compilation---
  U_monthly_map=fltarr(image_width,image_height)
  U_num_monthly_map=fltarr(image_width,image_height)
  v_monthly_map=fltarr(image_width,image_height)
  v_num_monthly_map=fltarr(image_width,image_height);--------------------loop_for_year--------------------------100_ID
start_year= ;example="2003"
end_year=  ;example="2019"

for year=start_year,end_year do begin

year_st=strtrim(string(year,format='(I4.4)'),2)
;==================================================

;---------------------------if oisst
path_input3= ;${filepath} example='E:\DATA IND V2\Olah\CCMP\Indonesia_V2\uwnd\Climatology\uwnd'+month_st+'.sav'
datanc3=findfile(path_input3,count.sav=num_ncf3)
;stop
if num_ncf3 gt 0 then begin
;stop
for inc3=0,num_ncf3-1 do begin
;stop
;print,datanc3[inc3]
;stop
pos_filename3=strpos(datanc3[inc3],'\uwnd'+year_st)
filename3=strtrim(strmid(datanc3[inc3],pos_filename3+5,20),2)
print, filename3
;
;stop
day_st=strtrim(strmid(filename3,6,2),2)
;stop
restore, datanc3[inc3]
emtx=monthly_map_u
restore, ;${filepath},example:'E:\DATA IND V2\Olah\CCMP\Indonesia_V2\uwnd\Climatology\uwnd'+month_st+'.sav'

emty=monthly_map_v

;stop
;--------------------land_cloud-----------------
;indx_land_cloud=where(SST_map eq 0,count_land_cloud)
;SST_map[indx_land_cloud]=9999.0

;--------------------SST-----------------
indx_u=where(emtx lt 900.,count_u)
indx_v=where(emty lt 900.,count_v)
;stop
;================default_for_monthly_mean_calculation=========
u_monthly_map[indx_u]=u_monthly_map[indx_u]+emtx[indx_u]
u_num_monthly_map[indx_u]=u_num_monthly_map[indx_u]+1

v_monthly_map[indx_v]=v_monthly_map[indx_v]+emty[indx_v]
v_num_monthly_map[indx_v]=v_num_monthly_map[indx_v]+1
;stop
;=======================================================
endfor	;------------end_of_loop_for_all_files--------------------80_ID--------
endif
endfor  ;-------------------end_of_loop_of_month-----90_ID-----------
;============================================================
;*******************AVERAGING (default)****************for monthly composite
indx_u_monthly=where(u_num_monthly_map gt 0.,count_indx_u_monthly)

monthly_map_u=fltarr(image_width,image_height)+999.
;stop
monthly_map_u[indx_u_monthly]=u_monthly_map[indx_u_monthly]/float(u_num_monthly_map[indx_u_monthly])

indx_v_monthly=where(v_num_monthly_map gt 0.,count_indx_v_monthly)

monthly_map_v=fltarr(image_width,image_height)+999.
;stop
monthly_map_v[indx_v_monthly]=v_monthly_map[indx_v_monthly]/float(v_num_monthly_map[indx_v_monthly])
;============================================================
;============================================================
;stop
;*****************************:output monthly sst into binary files********************************
file_mkdir, ;${filepath} example='E:\DATA IND V2\Olah\CCMP\Indonesia_V2\uwnd\Climatology\
file_mkdir, ;${filepath} example='E:\DATA IND V2\Olah\CCMP\Indonesia_V2\vwnd\Climatology\
save, monthly_map_u, filename ='E:\DATA IND V2\Olah\CCMP\Indonesia_V2\uwnd\Climatology\uwnd'+month_st+'.sav'
save, monthly_map_v, filename ='E:\DATA IND V2\Olah\CCMP\Indonesia_V2\vwnd\Climatology\vwnd'+month_st+'.sav'
print,month
TOC

;=============================================================================

;stop
;endfor
;*********************************************************************************

endfor  ;-------------------end_of_loop_of_year----100_ID------------

;*******************AVERAGING (default)****************8****for all composite
;indx_sst_monthly=where(num_monthly_map gt 0,count_indx_sst_monthly)
;
;compile_map=intarr(image_width,image_height)+32766
;;SST_case_map=fltarr(image_width,image_height)+9999.;..................special for dsst
;
;;stop
;compile_map[indx_sst_monthly]=SST_monthly_map[indx_sst_monthly]/float(num_monthly_map[indx_sst_monthly])
;;============================================================
;;============================================================
;;stop
;;*****************************:output monthly sst into binary files********************************
;
;save, compile_map, filename ='N:\data\daily_idl_oaflux\SR\SR_all_compile_03-09.sav'
print,'finish'
;stop

!P.Region=0
!P.Position=0

end

