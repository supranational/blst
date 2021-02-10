// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

%module blst
%rename("%(strip:[blst_])s") "";    // prefix is redundant in named module

%include "exception.i"
#ifdef __cplusplus
%include "std_string.i"
%typemap(out) SELF* OUTPUT = SWIGTYPE*; // to be overridden as required
#else
#warning consider using C++ interface
#endif
%include "stdint.i"

%apply const char* { const byte*, const byte[ANY] }
%apply (const char *STRING, size_t LENGTH) { (const byte *STRING,
                                              size_t LENGTH) }

#if defined(SWIGPYTHON)

// some sorcery to allow assignments as output, e.g.
//      hash = blst.encode_to_g1(b"foo")
%typemap(in, numinputs=0) OBJECT *OUTPUT($1_basetype temp) %{ $1 = &temp; %}
%typemap(argout) OBJECT *OUTPUT {
    PyObject *obj = SWIG_NewPointerObj(memcpy(malloc(sizeof($1_basetype)),
                                              $1,sizeof($1_basetype)),
                                       $descriptor, SWIG_POINTER_NEW);
    $result = ($result==NULL) ? obj
                              : SWIG_Python_AppendOutput($result, obj);
}
%apply OBJECT *OUTPUT {
    blst_p1        *out, blst_p1        *out_pk, blst_p1        *out_sig,
    blst_p1_affine *out, blst_p1_affine *out_pk, blst_p1_affine *out_sig,
    blst_p2        *out, blst_p2        *out_pk, blst_p2        *out_sig,
    blst_p2_affine *out, blst_p2_affine *out_pk, blst_p2_affine *out_sig,
    blst_scalar    *out, blst_scalar    *out_SK,
    blst_fp12      *out
}

// accept 'bytes' and 'bytearray' as inputs...
%typemap(in) const byte* %{
    if (PyBytes_Check($input)) {
        char *buf;
        Py_ssize_t nbytes;

        if (PyBytes_AsStringAndSize($input, &buf, &nbytes) < 0)
            SWIG_exception_fail(SWIG_TypeError, "in method '$symname'");

        $1 = ($1_ltype)buf;
    } else if (PyByteArray_Check($input)) {
        $1 = ($1_ltype)PyByteArray_AsString($input);
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting 'bytes' or 'bytearray'");
    }
%}
%typemap(freearg) const byte* ""

%typemap(in) const byte[ANY] %{
    if (PyBytes_Check($input)) {
        char *buf;
        Py_ssize_t nbytes;

        if (PyBytes_AsStringAndSize($input, &buf, &nbytes) < 0)
            SWIG_exception_fail(SWIG_TypeError, "in method '$symname'");

        if (nbytes != $1_dim0)
            SWIG_exception_fail(SWIG_ValueError, "in method '$symname', "
                                                 "expecting $1_dim0 bytes");
        $1 = ($1_ltype)buf;
    } else if (PyByteArray_Check($input)) {
        if (PyByteArray_Size($input) != $1_dim0)
            SWIG_exception_fail(SWIG_ValueError, "in method '$symname', "
                                                 "expecting $1_dim0 bytes");
        $1 = ($1_ltype)PyByteArray_AsString($input);
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting 'bytes' or 'bytearray'");
    }
%}
%typemap(freearg) const byte[ANY] ""

%typemap(in) (const byte *STRING, size_t LENGTH) %{
    if (PyBytes_Check($input)) {
        char *buf;
        Py_ssize_t nbytes;

        if (PyBytes_AsStringAndSize($input, &buf, &nbytes) < 0)
            SWIG_exception_fail(SWIG_ValueError, "in method '$symname'");

        $1 = ($1_ltype)buf;
        $2 = nbytes;
    } else if (PyByteArray_Check($input)) {
        $1 = ($1_ltype)PyByteArray_AsString($input);
        $2 = PyByteArray_Size($input);
#ifdef Py_USING_UNICODE
    } else if (PyUnicode_Check($input)) {
        char *buf;
        Py_ssize_t nbytes;
        PyObject *obj = PyUnicode_AsUTF8String($input);

        if (obj == NULL || PyBytes_AsStringAndSize(obj, &buf, &nbytes) < 0)
            SWIG_exception_fail(SWIG_ValueError, "in method '$symname'");

        $1 = ($1_ltype)alloca($2 = nbytes);
        memcpy($1, buf, $2);
        Py_DECREF(obj);
#endif
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting 'bytes' or 'bytearray'");
    }
%}

// let users use Python 'int', 'bytes' and 'bytearray' as scalars
%typemap(in) (const byte* scalar, size_t nbits) %{
    if (PyBytes_Check($input)) {
        char *scalar;
        Py_ssize_t nbytes;

        if (PyBytes_AsStringAndSize($input, &scalar, &nbytes) < 0)
            SWIG_exception_fail(SWIG_TypeError, "in method '$symname'");

        $1 = ($1_ltype)scalar;
        $2 = 8 * nbytes;
    } else if (PyByteArray_Check($input)) {
        $1 = ($1_ltype)PyByteArray_AsString($input);
        $2 = 8 * PyByteArray_Size($input);
    } else if (PyLong_Check($input)) {
        size_t nbytes;

        $2 = _PyLong_NumBits($input);
        $1 = ($1_ltype)alloca(nbytes = ($2 + 7)/8);

        if (_PyLong_AsByteArray((PyLongObject*)$input, $1, nbytes, 1, 0) < 0)
            SWIG_exception_fail(SWIG_OverflowError, "in method '$symname'");
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting 'int', 'bytes' "
                                            "or 'bytearray'");
    }
%}

#ifdef __cplusplus
%typemap(out) BLST_ERROR %{
    if ($1 != BLST_SUCCESS) {
        SWIG_exception(SWIG_ValueError, BLST_ERROR_str[$1]);
        SWIG_fail;
    }
    $result = SWIG_From_int($1);
%}

// return |this|
%typemap(out) SELF* OUTPUT %{ (void)$1; Py_INCREF($result = swig_obj[0]); %}
#endif

#elif defined(SWIGJAVA)

%header %{
#ifdef __cplusplus
# define JCALL(func, ...) jenv->func(__VA_ARGS__)
#else
# define JCALL(func, ...) (*jenv)->func(jenv, __VA_ARGS__)
#endif
%}

%include "enums.swg"
%include "arrays_java.i"
%javaconst(1);

#if SWIG_VERSION < 0x040000
%apply (char *STRING, size_t LENGTH) { (const byte *STRING, size_t LENGTH) }
#endif

%pragma(java) jniclassimports=%{
import java.io.*;
import java.nio.file.*;
%}
%pragma(java) jniclasscode=%{
    final static String libName = System.mapLibraryName("$module");
    final static String resName = System.getProperty("os.name").replaceFirst(" .*","")
                                + "/" + System.getProperty("os.arch")
                                + "/" + libName;
    static {
        InputStream res = $imclassname.class.getResourceAsStream(resName);
        if (res == null) {
            try {
                System.loadLibrary("$module");
            } catch (UnsatisfiedLinkError e) {
                String[] cmd = System.getProperty("sun.java.command").split("/");
		if (!"$imclassname".equals(cmd[cmd.length-1]))
                    // suppress exception if 'main' below is executed
                    throw new RuntimeException(e.getMessage());
	    }
        } else {
            // unpack shared library into a temporary directory and load it
            try {
                Path tmpdir = Files.createTempDirectory("$module@");
                tmpdir.toFile().deleteOnExit();
                Path tmpdll = Paths.get(tmpdir.toString(), libName);
                tmpdll.toFile().deleteOnExit();
                Files.copy(res, tmpdll, StandardCopyOption.REPLACE_EXISTING);
                res.close();
                System.load(tmpdll.toString());
            } catch (IOException e) {
                throw new RuntimeException(e.getMessage());
            }
        }
    }
    public static void main(String argv[]) {
        System.out.println(resName);
    }
%}

#ifdef __cplusplus
// Extensive sorcery to shift memory management to JVM GC. General idea is
// to use Java long[] as opaque storage for blst data. Methods that return
// new objects allocate suitably sized long[] arrays from JVM heap,
// references to which are then assigned to |swigCPtr| on the Java side.
// And when passed back to JNI, |swigCPtr|s are dereferenced with
// GetLongArrayElements... And no destructors!
%nodefaultdtor;
%typemap(javafinalize)  SWIGTYPE ""
%typemap(javadestruct)  SWIGTYPE ""

%typemap(javabody)      SWIGTYPE %{
  private transient long[] swigCPtr;

  protected $javaclassname(long[] cPtr) { swigCPtr = cPtr; }

  protected static long[] getCPtr($javaclassname obj) { return obj.swigCPtr; }

  public $javaclassname dup() { return new $javaclassname(swigCPtr.clone()); }
%}
%ignore dup;
%typemap(javaconstruct) SWIGTYPE { this($imcall); }
%typemap(jni)           SWIGTYPE, SWIGTYPE&, SWIGTYPE* "jlongArray"
%typemap(jtype)         SWIGTYPE, SWIGTYPE&, SWIGTYPE* "long[]"
%typemap(javaout)       SWIGTYPE, SWIGTYPE&, SWIGTYPE* {
    return new $javaclassname($jnicall);
}
%typemap(in)            SWIGTYPE&, SWIGTYPE* %{
    $1 = ($1_ltype)JCALL(GetLongArrayElements, $input, 0);
%}
%typemap(out)           SWIGTYPE&, SWIGTYPE* %{
    if ($1 != $null) {
        size_t sz = (sizeof($1_basetype) + sizeof(jlong) - 1)/sizeof(jlong);
        $result = JCALL(NewLongArray, sz);
        if ($result != $null)
            JCALL(SetLongArrayRegion, $result, 0, sz, (const jlong *)$1);
    }
%}
%typemap(out)           SWIGTYPE {
    size_t sz = (sizeof($1_basetype) + sizeof(jlong) - 1)/sizeof(jlong);
    $result = JCALL(NewLongArray, sz);
    if ($result != $null)
        JCALL(SetLongArrayRegion, $result, 0, sz, (const jlong *)&$1);
}
%typemap(newfree)       SWIGTYPE* "delete $1;"
%typemap(freearg)       SWIGTYPE&, SWIGTYPE* %{
    JCALL(ReleaseLongArrayElements, $input, (jlong *)$1, 0);
%}
%typemap(freearg) const SWIGTYPE&, const SWIGTYPE* %{
    JCALL(ReleaseLongArrayElements, $input, (jlong *)$1, JNI_ABORT);
%}
%typemap(freearg) const std::string& ""

// I wish |jenv| was available in the constructor, so that NewLongArray
// could be called at once, without having to resort to matching
// %typemap(out)...
%extend blst::Pairing {
    Pairing(bool hash_or_encode, const std::string& DST)
    {   size_t sz = blst_pairing_sizeof();
        size_t SZ = (sz + DST.size() + sizeof(jlong) - 1)/sizeof(jlong);
        blst_pairing *ret = (blst_pairing *)malloc(SZ*sizeof(jlong));
        if (DST.size() != 0) {
            byte *dst = (byte *)ret + sz;
            memcpy(dst, DST.data(), DST.size());
            blst_pairing_init(ret, hash_or_encode, dst, DST.size());
        } else {
            blst_pairing_init(ret, hash_or_encode, NULL, 0);
        }
        return (Pairing *)ret;
    }
}
%typemap(out) blst::Pairing* {
    size_t sz = blst_pairing_sizeof();
    size_t SZ = (sz + arg2->size() + sizeof(jlong) - 1)/sizeof(jlong);
    $result = JCALL(NewLongArray, SZ);
    if ($result != $null)
        JCALL(SetLongArrayRegion, $result, 0, SZ, (const jlong *)$1);
}
%typemap(newfree) blst::Pairing* "free($1);"

%typemap(javaout) SELF* OUTPUT { $jnicall; return this; }
%typemap(out)     SELF* OUTPUT "(void)$1;"
%typemap(jni)     SELF* OUTPUT "void"
%typemap(jtype)   SELF* OUTPUT "void"
#endif

%typemap(throws) BLST_ERROR %{
    SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException,
                                  BLST_ERROR_str[$1]);
%}

// handle input const byte[] more efficiently...
%apply signed char[] { const byte* }
%typemap(in) const byte* %{
    $1 = ($1_ltype)JCALL(GetByteArrayElements, $input, 0);
%}
%typemap(argout)  const byte* ""
%typemap(freearg) const byte* %{
    JCALL(ReleaseByteArrayElements, $input, (jbyte *)$1, JNI_ABORT);
%}

%apply const byte* { const byte[ANY] }
%typemap(in) const byte[ANY] {
    size_t sz = JCALL(GetArrayLength, $input);
    if (sz != $1_dim0) {
        SWIG_JavaThrowException(jenv, SWIG_JavaIndexOutOfBoundsException,
                                      "BLST_ERROR: input size mismatch");
        return $null;
    }
    $1 = ($1_ltype)JCALL(GetByteArrayElements, $input, 0);
}

// let users use 'java.math.BigInteger' as scalars
%typemap(in) (const byte* scalar, size_t nbits) %{
    $2 = JCALL(GetArrayLength, $input);
    $1 = ($1_ltype)alloca($2);
    JCALL(GetByteArrayRegion, $input, 0, $2, (jbyte*)$1);
    if (*(jbyte*)$1 < 0) {
        SWIG_JavaThrowException(jenv, SWIG_JavaIllegalArgumentException,
                                      "expecting unsigned value");
        return $null;
    }
    {   // BigInteger.toByteArray() emits big-endian, flip the order...
        size_t i, j;
        for(i=0, j=$2-1; i<$2/2; i++, j--) {
            $*1_ltype t=$1[i]; $1[i]=$1[j]; $1[j]=t;
        }
    }
    if ($1[$2-1] == 0)
        $2--;
    $2 *= 8;
%}
%typemap(jni)    (const byte* scalar, size_t nbits) "jbyteArray"
%typemap(jtype)  (const byte* scalar, size_t nbits) "byte[]"
%typemap(jstype) (const byte* scalar, size_t nbits) "java.math.BigInteger"
%typemap(javain) (const byte* scalar, size_t nbits) "$javainput.toByteArray()"

#elif defined(SWIGJAVASCRIPT) && defined(SWIG_JAVASCRIPT_V8)

%header %{
#if V8_MAJOR_VERSION >= 8
# define GetData() GetBackingStore()->Data()
#else
# define GetData() GetContents().Data()
#endif
%}

%typemap(throws) BLST_ERROR %{ SWIG_V8_Raise(BLST_ERROR_str[$1]); SWIG_fail; %}

%typemap(in) const byte* %{
    if ($input->IsArrayBufferView()) {
        auto av = v8::Local<v8::ArrayBufferView>::Cast($input);
        auto buf = av->Buffer();
        $1 = ($1_ltype)buf->GetData() + av->ByteOffset();
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting <Buffer>");
    }
%}
%typemap(argout)  const byte* ""
%typemap(freearg) const byte* ""

%apply const byte* { const byte[ANY] }
%typemap(in) const byte[ANY] %{
    if ($input->IsArrayBufferView()) {
        auto av = v8::Local<v8::ArrayBufferView>::Cast($input);
        if (av->ByteLength() != $1_dim0)
            SWIG_exception_fail(SWIG_IndexError, "in method '$symname', "
                                                 "expecting $1_dim0 bytes");
        auto buf = av->Buffer();
        $1 = ($1_ltype)buf->GetData() + av->ByteOffset();
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting <Buffer>");
    }
%}

// let users use JavaScript <BigInt> and <Buffer> as scalars
%typemap(in) (const byte* scalar, size_t nbits) %{
    if ($input->IsArrayBufferView()) {
        auto av = v8::Local<v8::ArrayBufferView>::Cast($input);
        auto buf = av->Buffer();
        $1 = ($1_ltype)buf->GetData() + av->ByteOffset();
        $2 = 8*av->ByteLength();
#if V8_MAJOR_VERSION >=6 && V8_MINOR_VERSION >= 8
    } else if ($input->IsBigInt()) {
        auto bi = v8::Local<v8::BigInt>::Cast($input);
        int sign, word_count = bi->WordCount();
        uint64_t* words = (uint64_t*)alloca($2 = word_count*sizeof(uint64_t));

        bi->ToWordsArray(&sign, &word_count, words);
        if (sign)
            SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                                "expecting unsigned value");
        $1 = ($1_ltype)words;
        $2 *= 8;

        const union {
            long one;
            char little;
        } is_endian = { 1 };

        if (!is_endian.little) {
            byte* p = $1;
            for (int i = 0; i < word_count; i++) {
                uint64_t val = words[i];
                for (size_t j = 0; j < sizeof(val); j++, val >>= 8)
                    *p++ = (byte)val;
            }
        }
#endif
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting <Buffer> or <BigInt>");
    }
%}

%typemap(in) (const byte *STRING, size_t LENGTH) %{
    if ($input->IsArrayBufferView()) {
        auto av = v8::Local<v8::ArrayBufferView>::Cast($input);
        auto buf = av->Buffer();
        $1 = ($1_ltype)buf->GetData() + av->ByteOffset();
        $2 = av->ByteLength();
    } else if ($input->IsString()) {
        auto str = SWIGV8_TO_STRING($input);
        $2 = SWIGV8_UTF8_LENGTH(str);
        $1 = ($1_ltype)alloca($2);
        SWIGV8_WRITE_UTF8(str, (char *)$1, $2);
    } else {
        SWIG_exception_fail(SWIG_TypeError, "in method '$symname', "
                                            "expecting <Buffer> or <String>");
    }
%}

// return |this|
%typemap(out) SELF* OUTPUT %{ (void)$1; $result = args.Holder(); %}

#elif defined(SWIGPERL)

// let users use byte[] as scalars
%apply (const char *STRING, size_t LENGTH) { (const byte* scalar, size_t nbits) }
%typemap(check) (const byte* scalar, size_t nbits) %{ $2 *= 8; %}

#ifdef __cplusplus
// return |this|
%typemap(out) SELF* OUTPUT %{ (void)$1; argvi++; %}
#endif

#endif  // SWIG<language>

// everybody has a way to bundle pointer and buffer size, but C:-(
%apply (const byte *STRING, size_t LENGTH) {
       (const byte *msg,    size_t msg_len),
       (const byte *DST,    size_t DST_len),
       (const byte *aug,    size_t aug_len),
       (const byte *IKM,    size_t IKM_len),
       (const byte *info,   size_t info_len)
}

// some sorcery to return byte[] from serialization methods
%typemap(in, numinputs=0) byte out[ANY] (byte temp[$1_dim0]) %{ $1 = temp; %}
%typemap(argout) byte out[ANY] {
#if defined(SWIGPYTHON)
    PyObject *obj = SWIG_FromCharPtrAndSize((char *)$1, $1_dim0);
    $result = ($result==NULL) ? obj
                              : SWIG_Python_AppendOutput($result, obj);
#elif defined(SWIGJAVA)
    $result = JCALL(NewByteArray, $1_dim0);
    if ($result != $null) {
        JCALL(SetByteArrayRegion, $result, 0, $1_dim0, (const jbyte *)$1);
    }
#elif defined(SWIGJAVASCRIPT) && defined(SWIG_JAVASCRIPT_V8)
    auto ab = v8::ArrayBuffer::New(v8::Isolate::GetCurrent(), $1_dim0);
    memcpy(ab->GetData(), $1, $1_dim0);
    $result = v8::Uint8Array::New(ab, 0, $1_dim0);
#elif defined(SWIGPERL)
    $result = SWIG_FromCharPtrAndSize((char *)$1, $1_dim0); argvi++;
#else // TODO: figure out more language-specific ways to return multi-values...
    if ($result == NULL)
        $result = SWIG_FromCharPtrAndSize((char *)$1, $1_dim0);
#endif
}
%typemap(freearg) byte out[ANY] ""
#ifdef SWIGJAVA
%typemap(jni)     byte out[ANY] "jbyteArray"
%typemap(jtype)   byte out[ANY] "byte[]"
%typemap(jstype)  byte out[ANY] "byte[]"
%typemap(javaout) byte out[ANY] { return $jnicall; }
#endif
%apply byte out[ANY] {
    void to_bendian,    void blst_bendian_from_scalar,
    void to_lendian,    void blst_lendian_from_scalar,
    void serialize,     void blst_p1_serialize, void blst_p1_affine_serialize,
                        void blst_p2_serialize, void blst_p2_affine_serialize,
    void compress,      void blst_p1_compress,  void blst_p1_affine_compress,
                        void blst_p2_compress,  void blst_p2_affine_compress,
    void blst_sk_to_pk2_in_g1,  void blst_sign_pk2_in_g1,
    void blst_sk_to_pk2_in_g2,  void blst_sign_pk2_in_g2
}

#ifdef __cplusplus
%apply const std::string& { const std::string* }

#pragma SWIG nowarn=509,516

%ignore nullptr;
%ignore None;
%catches(BLST_ERROR) P1(const byte* in);
%catches(BLST_ERROR) P1_Affine(const byte* in);
%catches(BLST_ERROR) aggregate(const P1_Affine& in);

%catches(BLST_ERROR) P2(const byte* in);
%catches(BLST_ERROR) P2_Affine(const byte* in);
%catches(BLST_ERROR) aggregate(const P2_Affine& in);

// methods returning |this|
%apply SELF* OUTPUT {
    blst::P1* sign_with,    blst::P2* sign_with,
    blst::P1* hash_to,      blst::P2* hash_to,
    blst::P1* encode_to,    blst::P2* encode_to,
    blst::P1* mult,         blst::P2* mult,
    blst::P1* cneg,         blst::P2* cneg,
    blst::P1* neg,          blst::P2* neg,
    blst::P1* add,          blst::P2* add,
    blst::P1* dbl,          blst::P2* dbl,
    blst::PT* mul,          blst::PT* sqr,
    blst::PT* final_exp
}

typedef enum {
    BLST_SUCCESS = 0,
    BLST_BAD_ENCODING,
    BLST_POINT_NOT_ON_CURVE,
    BLST_POINT_NOT_IN_GROUP,
    BLST_AGGR_TYPE_MISMATCH,
    BLST_VERIFY_FAIL,
    BLST_PK_IS_INFINITY,
} BLST_ERROR;

%include "blst.hpp"

extern const blst::P1_Affine BLS12_381_G1;
extern const blst::P1_Affine BLS12_381_NEG_G1;
extern const blst::P2_Affine BLS12_381_G2;
extern const blst::P2_Affine BLS12_381_NEG_G2;

#else
%ignore blst_fr;
%ignore blst_fp;
%ignore blst_fp2;
%ignore blst_fp6;
%ignore blst_scalar_from_uint32;
%ignore blst_scalar_from_uint64;
%ignore blst_uint32_from_scalar;
%ignore blst_uint64_from_scalar;
%ignore blst_pairing_init;
%ignore blst_pairing_get_dst;

%include "blst.h"
%include "blst_aux.h"
%extend blst_pairing {
    blst_pairing(bool hash_or_encode, const byte *DST DEFNULL,
                                      size_t DST_len DEFNULL)
    {   void *ret = malloc(blst_pairing_sizeof());
        if (DST_len != 0) {
            void *dst = malloc(DST_len);
            memcpy(dst, DST, DST_len);
            blst_pairing_init(ret, hash_or_encode, dst, DST_len);
        } else {
            blst_pairing_init(ret, hash_or_encode, NULL, 0);
        }
        return ret;
    }
    ~blst_pairing()
    {   void *dst = (void *)blst_pairing_get_dst($self);
        if (dst != NULL) free(dst);
        free($self);
    }
}
#endif

%begin %{
#ifdef __cplusplus
# include "blst.hpp"
using namespace blst;
#else
# include "blst.h"
#endif

static const char *const BLST_ERROR_str [] = {
    "BLST_ERROR: success",
    "BLST_ERROR: bad point encoding",
    "BLST_ERROR: point is not on curve",
    "BLST_ERROR: point is not in group",
    "BLST_ERROR: context type mismatch",
    "BLST_ERROR: verify failed",
    "BLST_ERROR: public key is infinite",
};

#define SWIG_PYTHON_STRICT_BYTE_CHAR

#ifdef _WIN32
# include <malloc.h>
# ifndef alloca
#  define alloca(s) _alloca(s)
# endif
#endif
%}

#if defined(SWIGPYTHON) || defined(SWIGPERL)
%include "cdata.i"
#endif

#if defined(SWIGJAVASCRIPT) && defined(SWIG_JAVASCRIPT_V8)
%wrapper %{
#undef NODE_MODULE
#define NODE_MODULE NODE_MODULE_CONTEXT_AWARE
%}
#endif

#if defined(SWIGJAVA)
/* this might need a refinement in the future if SWIG changes the way
 * it handles 'jlong' JNI type */
%begin %{
#if defined(__MINGW32__) && defined(__int64)
# undef __int64
#endif
%}
#endif
