#include "ecli_c.h"
#include <string.h>
#include <stdio.h>
#include <io.h>
#include <errno.h>

static void xstrerror(void);

static char err_text[1024];
/******************************************************/

EIF_POINTER FILE_open_read (EIF_POINTER name)
{
    FILE* res;

    if (!strcmp ((char*)name, "stdin"))
        res = stdin;
    else
        res = fopen ((const char*)name, "r");

    if (res)
        return (EIF_POINTER) res;
    else
    {
      xstrerror();
      return (EIF_POINTER)0;
    }
}
/******************************************************/

EIF_POINTER FILE_open_write (EIF_POINTER name)
{
    FILE* res;

    if (!strcmp((char*)name, "stdout"))
        res = stdout;
    else if (!strcmp((char*)name, "stderr"))
        res = stderr;
    else
        res = fopen ((const char*)name, "w");

    if (res)
        return (EIF_POINTER) res;
    else
    {
        xstrerror();
        return (EIF_POINTER)0;
    }
}
/******************************************************/

EIF_POINTER FILE_open_append (EIF_POINTER name)
{
    FILE* res;

    res = fopen ((const char*)name, "a");

    if (res)
        return (EIF_POINTER) res;
    else
    {
        xstrerror();
        return (EIF_POINTER)0;
    }
}
/******************************************************/

EIF_POINTER FILE_open_read_write (EIF_POINTER name)
{
    FILE* res;

    res = fopen ((const char*)name, "w+");

    if (res)
        return (EIF_POINTER) res;
    else
    {
        xstrerror();
        return (EIF_POINTER)0;
    }
}
/******************************************************/

void FILE_close(EIF_POINTER fp)
{
    (void) fclose ((FILE*)fp);
}
/******************************************************/

EIF_POINTER FILE_error_message(void)
{
    return (EIF_POINTER) err_text;
}
/******************************************************/

void FILE_putint (EIF_POINTER fp, EIF_INTEGER i)
{
    fprintf ((FILE*)fp, "%d", (int)i);
}
/******************************************************/

void FILE_putstr (EIF_POINTER fp,
                  EIF_POINTER sp)

{
    fprintf ((FILE*)fp, "%s", (char*)sp);
}
/******************************************************/

void FILE_putreal (EIF_POINTER fp,
                   EIF_REAL    r)

{
    fprintf ((FILE*)fp, "%f", (float)r);
}
/******************************************************/

void FILE_putdouble (EIF_POINTER fp,
                     EIF_DOUBLE  d)

{
    fprintf ((FILE*)fp, "%f", (double)d);
}
/******************************************************/

void FILE_newline (EIF_POINTER fp)

{
    fprintf ((FILE*)fp, "\n");
}
/******************************************************/

EIF_BOOLEAN FILE_readint (EIF_POINTER fp,
                          EIF_POINTER ip)

{
    int res;

    if (fscanf ((FILE*)fp, "%d", &res))
    {
        *((EIF_INTEGER*)ip) = res;
        return (EIF_BOOLEAN) 1;
    }
    else
    {
        return (EIF_BOOLEAN) 0;
    }
}
/******************************************************/

EIF_BOOLEAN FILE_readreal (EIF_POINTER fp,
                           EIF_POINTER rp)

{
    float res;

    if (fscanf ((FILE*)fp, "%f", &res))
    {
        *((EIF_REAL*)rp) = res;
        return (EIF_BOOLEAN) 1;
    }
    else
    {
        return (EIF_BOOLEAN) 0;
    }
}
/******************************************************/

EIF_BOOLEAN FILE_readdouble (EIF_POINTER fp,
                             EIF_POINTER dp)

{
    double res;

    if (fscanf ((FILE*)fp, "%lf", &res))
    {
        *((EIF_DOUBLE*)dp) = res;
        return (EIF_BOOLEAN) 1;
    }
    else
    {
        return (EIF_BOOLEAN) 0;
    }
}
/******************************************************/

EIF_BOOLEAN FILE_readchar (EIF_POINTER fp,
                           EIF_POINTER cp)

{
    char res;

    if (fscanf ((FILE*)fp, "%c", &res))
    {
        *((EIF_CHARACTER*)cp) = res;
        return (EIF_BOOLEAN) 1;
    }
    else
    {
        return (EIF_BOOLEAN) 0;
    }
}
/******************************************************/

EIF_BOOLEAN FILE_eof (EIF_POINTER fp)

{
    return (EIF_BOOLEAN) feof ((FILE*)fp);
}
/******************************************************/

EIF_BOOLEAN FILE_exists (EIF_POINTER path)
{
		return (EIF_BOOLEAN) ((access (path, 0)==0)?1:0);
}


#define BSIZE 1024

static char buf[BSIZE];

EIF_POINTER FILE_readline (EIF_POINTER fp)
{
    int n;

    if (fgets (buf, BSIZE, (FILE*)fp))
    {
      n = strlen(buf);
        if (buf[n-1] == '\n')
            buf[n-1] = '\0';
        return (EIF_POINTER)buf;
    }
    else
        return (EIF_POINTER)0;
}
/******************************************************/

static void xstrerror(void)
{
    strcpy (err_text, strerror(errno));

    return;
}

