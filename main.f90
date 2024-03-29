module fft_mod
    integer,parameter::dp=selected_real_kind(15,300)
    real(kind=dp),parameter::pi=3.141592653589793238460_dp
contains
    recursive subroutine fft(x)!fft递归实现
        complex(kind=dp), dimension(:), intent(inout)::x
        complex(kind=dp)::t
        integer::N!信号点数
        integer::i!循环变量
        integer::omp_get_thread_num()
        integer
        complex(kind=dp), dimension(:), allocatable::even,odd!偶序列/奇序列
        N=size(x)
        if(N .le. 1) return!
        allocate(odd((N+1)/2))
        allocate(even(N/2))
        ! divide
        odd =x(1:N:2)
        even=x(2:N:2)
        ! conquer
        call fft(odd)
        call fft(even)
        ! combine
        ! 在这里实现并行
        !$OMP PARALLEL
        !$OMP DO
        do i=1,N/2
            t=exp(cmplx(0.0_dp,-2.0_dp*pi*real(i-1,dp)/real(N,dp),kind=dp))*even(i)
            x(i)     = odd(i) + t
            x(i+N/2) = odd(i) - t
        end do
        !$OMP END DO
        !$OMP END PARALLEL
        deallocate(odd)
        deallocate(even)
    end subroutine fft
end module fft_mod

program test
    use fft_mod
!    complex(kind=dp), dimension(8) :: data = (/1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0/)
!    integer :: i
!
!    call fft(data)
!
!    do i=1,8
!        write(*,'("(", F20.15, ",", F20.15, "i )")') data(i)
!    end do
    complex(kind=dp),allocatable::data
end program test

