     H DFTACTGRP(*NO) OPTION(*SRCSTMT)

     D msg           s             50a

     C                   eval      msg = 'Hola Mundo SQLRPGLE'
     C                   exsr      WRITMSG
     C                   eval      *inlr = *on
     C                   return

     begsr     WRITMSG
     C                   DSPLY     msg
     endsr