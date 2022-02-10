program getCodesVersion
!
! Displays the api_version returned by codes_get_api_version
! 

 USE eccodes

 IMPLICIT NONE

 INTEGER :: iret
 INTEGER :: api_version=0

 CALL codes_get_api_version(api_version,iret)
 write(*,*)'Using eccodes version: ',api_version

end program getCodesVersion
