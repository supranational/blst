{
  'targets': [
    {
      'target_name': 'blst',
      'sources': [
        'blst_wrap.cpp',
        '../../src/server.c',
        '../../build/assembly.S'
      ],
      'include_dirs': [ '..' ],
      'cflags_cc': [ '-fexceptions' ],
    },
  ]
}
