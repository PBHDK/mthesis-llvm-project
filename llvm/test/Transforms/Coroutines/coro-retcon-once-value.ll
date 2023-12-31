; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes='default<O2>' -S | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

define {ptr, i32} @f(ptr %buffer, ptr %array) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  PostSpill:
; CHECK-NEXT:    store ptr [[ARRAY:%.*]], ptr [[BUFFER:%.*]], align 8
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, ptr [[ARRAY]], align 4
; CHECK-NEXT:    [[LOAD_POS:%.*]] = icmp sgt i32 [[LOAD]], 0
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[LOAD_POS]], ptr @f.resume.0, ptr @f.resume.1
; CHECK-NEXT:    [[SPEC_SELECT4:%.*]] = tail call i32 @llvm.smax.i32(i32 [[LOAD]], i32 0)
; CHECK-NEXT:    [[TMP0:%.*]] = insertvalue { ptr, i32 } poison, ptr [[SPEC_SELECT]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr, i32 } [[TMP0]], i32 [[SPEC_SELECT4]], 1
; CHECK-NEXT:    ret { ptr, i32 } [[TMP1]]
;
entry:
  %id = call token @llvm.coro.id.retcon.once(i32 8, i32 8, ptr %buffer, ptr @prototype, ptr @allocate, ptr @deallocate)
  %hdl = call ptr @llvm.coro.begin(token %id, ptr null)
  %load = load i32, ptr %array
  %load.pos = icmp sgt i32 %load, 0
  br i1 %load.pos, label %pos, label %neg

pos:
  %unwind0 = call i1 (...) @llvm.coro.suspend.retcon.i1(i32 %load)
  br i1 %unwind0, label %cleanup, label %pos.cont

pos.cont:
  store i32 0, ptr %array, align 4
  br label %cleanup

neg:
  %unwind1 = call i1 (...) @llvm.coro.suspend.retcon.i1(i32 0)
  br i1 %unwind1, label %cleanup, label %neg.cont

neg.cont:
  store i32 10, ptr %array, align 4
  br label %cleanup

cleanup:
  call i1 @llvm.coro.end(ptr %hdl, i1 0)
  unreachable
}

define void @test(ptr %array) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca [8 x i8], align 8
; CHECK-NEXT:    store ptr [[ARRAY:%.*]], ptr [[TMP0]], align 8
; CHECK-NEXT:    [[LOAD_I:%.*]] = load i32, ptr [[ARRAY]], align 4
; CHECK-NEXT:    [[LOAD_POS_I:%.*]] = icmp sgt i32 [[LOAD_I]], 0
; CHECK-NEXT:    [[SPEC_SELECT_I:%.*]] = select i1 [[LOAD_POS_I]], ptr @f.resume.0, ptr @f.resume.1
; CHECK-NEXT:    [[SPEC_SELECT4_I:%.*]] = tail call i32 @llvm.smax.i32(i32 [[LOAD_I]], i32 0)
; CHECK-NEXT:    tail call void @print(i32 [[SPEC_SELECT4_I]])
; CHECK-NEXT:    call void [[SPEC_SELECT_I]](ptr nonnull [[TMP0]], i1 zeroext false)
; CHECK-NEXT:    ret void
;
entry:
  %0 = alloca [8 x i8], align 8
  %prepare = call ptr @llvm.coro.prepare.retcon(ptr @f)
  %result = call {ptr, i32} %prepare(ptr %0, ptr %array)
  %value = extractvalue {ptr, i32} %result, 1
  call void @print(i32 %value)
  %cont = extractvalue {ptr, i32} %result, 0
  call void %cont(ptr %0, i1 zeroext 0)
  ret void
}

;   Unfortunately, we don't seem to fully optimize this right now due
;   to some sort of phase-ordering thing.

declare token @llvm.coro.id.retcon.once(i32, i32, ptr, ptr, ptr, ptr)
declare ptr @llvm.coro.begin(token, ptr)
declare i1 @llvm.coro.suspend.retcon.i1(...)
declare i1 @llvm.coro.end(ptr, i1)
declare ptr @llvm.coro.prepare.retcon(ptr)

declare void @prototype(ptr, i1 zeroext)

declare noalias ptr @allocate(i32 %size)
declare void @deallocate(ptr %ptr)

declare void @print(i32)

