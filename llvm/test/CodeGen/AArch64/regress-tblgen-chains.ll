; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=arm64-apple-ios7.0 -frame-pointer=all -o - %s | FileCheck %s

; When generating DAG selection tables, TableGen used to only flag an
; instruction as needing a chain on its own account if it had a built-in pattern
; which used the chain. This meant that the AArch64 load/stores weren't
; recognised and so both loads from %locvar below were coalesced into a single
; LS8_LDR instruction (same operands other than the non-existent chain) and the
; increment was lost at return.

; This was obviously a Bad Thing.

declare void @bar(ptr)

define i64 @test_chains() {
; CHECK-LABEL: test_chains:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #32
; CHECK-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; CHECK-NEXT:    add x29, sp, #16
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    sub x0, x29, #1
; CHECK-NEXT:    bl _bar
; CHECK-NEXT:    ldurb w8, [x29, #-1]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    and x0, x8, #0xff
; CHECK-NEXT:    sturb w8, [x29, #-1]
; CHECK-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #32
; CHECK-NEXT:    ret

  %locvar = alloca i8

  call void @bar(ptr %locvar)

  %inc.1 = load i8, ptr %locvar
  %inc.2 = zext i8 %inc.1 to i64
  %inc.3 = add i64 %inc.2, 1
  %inc.4 = trunc i64 %inc.3 to i8
  store i8 %inc.4, ptr %locvar


  %ret.1 = load i8, ptr %locvar
  %ret.2 = zext i8 %ret.1 to i64
  ret i64 %ret.2
}
