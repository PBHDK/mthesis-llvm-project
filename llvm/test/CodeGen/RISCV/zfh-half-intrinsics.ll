; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+zfh \
; RUN:   -verify-machineinstrs -target-abi ilp32f | \
; RUN:   FileCheck -check-prefix=RV32IZFH %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+zfh \
; RUN:   -verify-machineinstrs -target-abi lp64f | \
; RUN:   FileCheck -check-prefix=RV64IZFH %s
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=zhinx \
; RUN:   -verify-machineinstrs -target-abi ilp32 | \
; RUN:   FileCheck -check-prefix=RV32IZHINX %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=zhinx \
; RUN:   -verify-machineinstrs -target-abi lp64 | \
; RUN:   FileCheck -check-prefix=RV64IZHINX %s
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+d \
; RUN:   -mattr=+zfh -verify-machineinstrs -target-abi ilp32d | \
; RUN:   FileCheck -check-prefix=RV32IDZFH %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+d \
; RUN:   -mattr=+zfh -verify-machineinstrs -target-abi lp64d | \
; RUN:   FileCheck -check-prefix=RV64IDZFH %s
; RUN: sed 's/iXLen/i32/g' %s | llc -mtriple=riscv32 -mattr=+zdinx \
; RUN:   -mattr=+zhinx -verify-machineinstrs -target-abi ilp32 | \
; RUN:   FileCheck -check-prefix=RV32IZDINXZHINX %s
; RUN: sed 's/iXLen/i64/g' %s | llc -mtriple=riscv64 -mattr=+zdinx \
; RUN:   -mattr=+zhinx -verify-machineinstrs -target-abi lp64 | \
; RUN:   FileCheck -check-prefix=RV64IZDINXZHINX %s

; These intrinsics require half to be a legal type.

declare iXLen @llvm.lrint.iXLen.f16(half)

define iXLen @lrint_f16(half %a) nounwind {
; RV32IZFH-LABEL: lrint_f16:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.w.h a0, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: lrint_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0
; RV64IZFH-NEXT:    ret
;
; RV32IZHINX-LABEL: lrint_f16:
; RV32IZHINX:       # %bb.0:
; RV32IZHINX-NEXT:    fcvt.w.h a0, a0
; RV32IZHINX-NEXT:    ret
;
; RV64IZHINX-LABEL: lrint_f16:
; RV64IZHINX:       # %bb.0:
; RV64IZHINX-NEXT:    fcvt.l.h a0, a0
; RV64IZHINX-NEXT:    ret
;
; RV32IDZFH-LABEL: lrint_f16:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.w.h a0, fa0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: lrint_f16:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.l.h a0, fa0
; RV64IDZFH-NEXT:    ret
;
; RV32IZDINXZHINX-LABEL: lrint_f16:
; RV32IZDINXZHINX:       # %bb.0:
; RV32IZDINXZHINX-NEXT:    fcvt.w.h a0, a0
; RV32IZDINXZHINX-NEXT:    ret
;
; RV64IZDINXZHINX-LABEL: lrint_f16:
; RV64IZDINXZHINX:       # %bb.0:
; RV64IZDINXZHINX-NEXT:    fcvt.l.h a0, a0
; RV64IZDINXZHINX-NEXT:    ret
  %1 = call iXLen @llvm.lrint.iXLen.f16(half %a)
  ret iXLen %1
}

declare i32 @llvm.lround.i32.f16(half)
declare i64 @llvm.lround.i64.f16(half)

define iXLen @lround_f16(half %a) nounwind {
; RV32IZFH-LABEL: lround_f16:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: lround_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rmm
; RV64IZFH-NEXT:    ret
;
; RV32IZHINX-LABEL: lround_f16:
; RV32IZHINX:       # %bb.0:
; RV32IZHINX-NEXT:    fcvt.w.h a0, a0, rmm
; RV32IZHINX-NEXT:    ret
;
; RV64IZHINX-LABEL: lround_f16:
; RV64IZHINX:       # %bb.0:
; RV64IZHINX-NEXT:    fcvt.l.h a0, a0, rmm
; RV64IZHINX-NEXT:    ret
;
; RV32IDZFH-LABEL: lround_f16:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: lround_f16:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.l.h a0, fa0, rmm
; RV64IDZFH-NEXT:    ret
;
; RV32IZDINXZHINX-LABEL: lround_f16:
; RV32IZDINXZHINX:       # %bb.0:
; RV32IZDINXZHINX-NEXT:    fcvt.w.h a0, a0, rmm
; RV32IZDINXZHINX-NEXT:    ret
;
; RV64IZDINXZHINX-LABEL: lround_f16:
; RV64IZDINXZHINX:       # %bb.0:
; RV64IZDINXZHINX-NEXT:    fcvt.l.h a0, a0, rmm
; RV64IZDINXZHINX-NEXT:    ret
  %1 = call iXLen @llvm.lround.iXLen.f16(half %a)
  ret iXLen %1
}

define i32 @lround_i32_f16(half %a) nounwind {
; RV32IZFH-LABEL: lround_i32_f16:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: lround_i32_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; RV64IZFH-NEXT:    ret
;
; RV32IZHINX-LABEL: lround_i32_f16:
; RV32IZHINX:       # %bb.0:
; RV32IZHINX-NEXT:    fcvt.w.h a0, a0, rmm
; RV32IZHINX-NEXT:    ret
;
; RV64IZHINX-LABEL: lround_i32_f16:
; RV64IZHINX:       # %bb.0:
; RV64IZHINX-NEXT:    fcvt.w.h a0, a0, rmm
; RV64IZHINX-NEXT:    ret
;
; RV32IDZFH-LABEL: lround_i32_f16:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: lround_i32_f16:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; RV64IDZFH-NEXT:    ret
;
; RV32IZDINXZHINX-LABEL: lround_i32_f16:
; RV32IZDINXZHINX:       # %bb.0:
; RV32IZDINXZHINX-NEXT:    fcvt.w.h a0, a0, rmm
; RV32IZDINXZHINX-NEXT:    ret
;
; RV64IZDINXZHINX-LABEL: lround_i32_f16:
; RV64IZDINXZHINX:       # %bb.0:
; RV64IZDINXZHINX-NEXT:    fcvt.w.h a0, a0, rmm
; RV64IZDINXZHINX-NEXT:    ret
  %1 = call i32 @llvm.lround.i32.f16(half %a)
  ret i32 %1
}
