program readSample
!
! Demonstrates bug at https://jira.ecmwf.int/browse/ECC-1200
! 
! The sense of preferLocalConcepts is inverted when encoding.
!

 USE, intrinsic :: iso_c_binding, only: C_LONG
 USE eccodes

 IMPLICIT NONE

 INTEGER :: gid,igid,lc,iret,err
 INTEGER(kind=C_LONG) :: api_version=0
 integer :: ilc,olc,ipn,opn,ipid,opid
 integer(kind=kindOfSize)           :: byte_size
 integer             :: ifile,ofile
 character(len=10)   :: isn,osn
 character(len=1), dimension(:), allocatable :: message

 interface
  function codes_get_api_version_c() bind(C, name='codes_get_api_version')
    import :: C_LONG
    integer(kind=C_LONG) :: codes_get_api_version_c
  end function
 end interface

 api_version = codes_get_api_version_c()

 write(*,*)'Using eccodes version: ',api_version
 if(api_version < 21800) stop 0
 call codes_open_file(ifile,'sample.grib2', 'r')
 call codes_open_file(ofile,'sample_out.grib2', 'w')
 call codes_grib_new_from_file(ifile,igid, iret)
 call codes_get_message_size(igid, byte_size)
 allocate(message(byte_size), stat=err)
 
 call codes_copy_message(igid, message)
 
 call codes_new_from_message(gid, message)

 CALL codes_get(igid,'preferLocalConcepts'  ,ilc,iret)
 CALL codes_get(gid,'preferLocalConcepts'   ,olc,iret)
 WRITE(6,*)'preferLocalConcepts at start - in:',ilc,' out:',olc

 write(6,*)'First we just copy input to output'
 CALL codes_get(igid,'paramId'  ,ipid)
 CALL codes_get(igid,'parameterNumber'  ,ipn)
 CALL codes_get(igid,'shortName'  ,isn)
 CALL codes_get(gid,'paramId'  ,opid)
 CALL codes_get(gid,'parameterNumber'  ,opn)
 CALL codes_get(gid,'shortName'  ,osn)
 write(6,*)' IN paramId, parameterNumber, shortName ',ipid,ipn,isn
 write(6,*)'OUT paramId, parameterNumber, shortName ',opid,opn,osn
 write(6,*)'Writing out message'
 CALL codes_write(gid,ofile)

 lc=0

 write(6,*)'Next we set preferLocalConcepts to ',lc
 write(6,*)' and set output shortName from input shortName'
 CALL codes_set(igid,'preferLocalConcepts'  ,lc,iret)
 CALL codes_set(gid,'preferLocalConcepts'  ,lc,iret)
 WRITE(6,*)'preferLocalConcepts->',lc
 CALL codes_get(igid,'paramId'  ,ipid)
 CALL codes_get(igid,'parameterNumber'  ,ipn)
 CALL codes_get(igid,'shortName'  ,isn)
 CALL codes_set(gid,'shortName'  ,isn)
 CALL codes_get(gid,'paramId'  ,opid)
 CALL codes_get(gid,'parameterNumber'  ,opn)
 CALL codes_get(gid,'shortName'  ,osn)
 write(6,*)' IN paramId, parameterNumber, shortName ',ipid,ipn,isn
 write(6,*)'OUT paramId, parameterNumber, shortName ',opid,opn,osn
 write(6,*)'Writing out message'
 CALL codes_write(gid,ofile)

 lc=1

 write(6,*)'Finally we set preferLocalConcepts to ',lc
 write(6,*)' and set output shortName from input shortName'
 CALL codes_set(igid,'preferLocalConcepts'  ,lc,iret)
 CALL codes_set(gid,'preferLocalConcepts'  ,lc,iret)
 WRITE(6,*)'preferLocalConcepts->',lc
 CALL codes_get(igid,'paramId'  ,ipid)
 CALL codes_get(igid,'parameterNumber'  ,ipn)
 CALL codes_get(igid,'shortName'  ,isn)
 CALL codes_set(gid,'shortName'  ,isn)
 CALL codes_get(gid,'paramId'  ,opid)
 CALL codes_get(gid,'parameterNumber'  ,opn)
 CALL codes_get(gid,'shortName'  ,osn)
 write(6,*)' IN paramId, parameterNumber, shortName ',ipid,ipn,isn
 write(6,*)'OUT paramId, parameterNumber, shortName ',opid,opn,osn
 write(6,*)'Writing out message'
 CALL codes_write(gid,ofile)

 CALL codes_close_file(ifile)
 CALL codes_close_file(ofile)

 CALL codes_release(gid)
 CALL codes_release(igid)

 write(6,*)
 if( ipid .eq. opid .and. ipn .eq. opn ) then
   write(6,*)'paramId, parameterNumber    match, ECCODES version OK'
 !  stop 0
 else
   write(6,*)'paramId, parameterNumber mismatch, ECCODES version BAD'
   error stop 1
 endif

end program readSample
