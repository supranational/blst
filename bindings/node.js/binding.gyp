{
  'targets': [
    {
      'target_name': 'blst',
      'sources': [
        'blst_wrap.cpp',
        '../../src/server.c',
      ],
      'include_dirs': [ '..' ],
      'conditions': [
        [ 'OS=="win"', {
            'cflags_cc': [ '/EHsc' ],
            'sources':   [ '../../build/win64/*-x86_64.asm' ],
          }, {
            'cflags_cc': [ '-fexceptions' ],
            'sources':   [ '../../build/assembly.S' ],
          }
        ],
        [ 'OS=="linux"', {
            'ldflags': [ '-Wl,-Bsymbolic' ],
          }
        ],
      ],
    },
  ]
}
