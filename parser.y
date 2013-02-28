/*
   Example using Flex and Bison with Qt.
   Copyright (C) 2013  Gonzalo Exequiel Pedone

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with This program.  If not, see <http://www.gnu.org/licenses/>.

   Email   : hipersayan DOT x AT gmail DOT com
   Web-Site: http://github.com/hipersayanX/FlexBisonQt
*/

%{
#include <QtGui>

extern int yylex(void);
void yyerror(const char *s);
%}

// Here we can define some custom variable types.
// The custom types must be of static size.
%union {
    QVariant *QVariant_t;
}

// Define the types for terminal expressions.
%token <QVariant_t> TOK_INTIGER
%token <QVariant_t> TOK_FLOAT
%token <QVariant_t> TOK_BOOLEAN
%token <QVariant_t> TOK_STRING

// Define the tokens for the symbols.
%token TOK_LEFTPAREN
%token TOK_RIGHTPAREN
%token TOK_LEFTCURLYBRACKET
%token TOK_RIGHTCURLYBRACKET
%token TOK_LEFTBRACKET
%token TOK_RIGHTBRACKET
%token TOK_COMMA
%token TOK_COLON

// Define the tokens for the keywords.
%token TOK_SIZE
%token TOK_SIZEF
%token TOK_POINT
%token TOK_POINTF
%token TOK_RECT
%token TOK_RECTF
%token TOK_LINE
%token TOK_LINEF
%token TOK_DATE
%token TOK_TIME
%token TOK_DATETIME
%token TOK_COLOR
%token TOK_BYTES
%token TOK_URL

// Define the types for non-terminal expressions.
%type <QVariant_t> variant
%type <QVariant_t> size
%type <QVariant_t> sizeF
%type <QVariant_t> point
%type <QVariant_t> pointF
%type <QVariant_t> rect
%type <QVariant_t> rectF
%type <QVariant_t> line
%type <QVariant_t> lineF
%type <QVariant_t> date
%type <QVariant_t> time
%type <QVariant_t> dateTime
%type <QVariant_t> color
%type <QVariant_t> bytes
%type <QVariant_t> url
%type <QVariant_t> number
%type <QVariant_t> variantListItems
%type <QVariant_t> variantList
%type <QVariant_t> variantMapPair
%type <QVariant_t> variantMapItems
%type <QVariant_t> variantMap

// Prevents memory leak in non-terminal expressions.
%destructor {delete $$;} variant
%destructor {delete $$;} size
%destructor {delete $$;} sizeF
%destructor {delete $$;} point
%destructor {delete $$;} pointF
%destructor {delete $$;} rect
%destructor {delete $$;} rectF
%destructor {delete $$;} line
%destructor {delete $$;} lineF
%destructor {delete $$;} date
%destructor {delete $$;} time
%destructor {delete $$;} dateTime
%destructor {delete $$;} color
%destructor {delete $$;} bytes
%destructor {delete $$;} url
%destructor {delete $$;} number
%destructor {delete $$;} variantListItems
%destructor {delete $$;} variantList
%destructor {delete $$;} variantMapPair
%destructor {delete $$;} variantMapItems
%destructor {delete $$;} variantMap

%%

/* Main expression to check. */
start: variant {qDebug() << *$1;};

variant: number
       | TOK_BOOLEAN
       | size
       | sizeF
       | point
       | pointF
       | rect
       | rectF
       | line
       | lineF
       | date
       | time
       | dateTime
       | color
       | bytes
       | url
       | TOK_STRING
       | variantList
       | variantMap
       ;

rect: TOK_RECT TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QRect());}
    | TOK_RECT TOK_LEFTPAREN point TOK_COMMA point TOK_RIGHTPAREN {
          // $$ is a reference to the result of the espression.
          // $1, $2, $3, ..., $N are references to each expression.
          $$ = new QVariant();
          *$$ = QRect($3->toPoint(), $5->toPoint());
      }
    | TOK_RECT TOK_LEFTPAREN point TOK_COMMA size TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QRect($3->toPoint(), $5->toSize());
      }
    | TOK_RECT TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QRect($3->toFloat(), $5->toFloat(), $7->toFloat(), $9->toFloat());
      }
    ;

rectF: TOK_RECTF TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QRectF());}
     | TOK_RECTF TOK_LEFTPAREN pointF TOK_COMMA pointF TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QRectF($3->toPointF(), $5->toPointF());
       }
     | TOK_RECTF TOK_LEFTPAREN pointF TOK_COMMA sizeF TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QRectF($3->toPointF(), $5->toSizeF());
       }
     | TOK_RECTF TOK_LEFTPAREN rect TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QRectF($3->toRect());
       }
     | TOK_RECTF TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QRectF($3->toFloat(), $5->toFloat(), $7->toFloat(), $9->toFloat());
       }
     ;

line: TOK_LINE TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QLine());}
    | TOK_LINE TOK_LEFTPAREN point TOK_COMMA point TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QLine($3->toPoint(), $5->toPoint());
      }
    | TOK_LINE TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QLine($3->toFloat(), $5->toFloat(), $7->toFloat(), $9->toFloat());
      }
    ;

lineF: TOK_LINEF TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QLineF());}
     | TOK_LINEF TOK_LEFTPAREN pointF TOK_COMMA pointF TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QLineF($3->toPointF(), $5->toPointF());
       }
     | TOK_LINEF TOK_LEFTPAREN line TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QLineF($3->toLine());
       }
     | TOK_LINEF TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QLineF($3->toFloat(), $5->toFloat(), $7->toFloat(), $9->toFloat());
       }
     ;

point: TOK_POINT TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QPoint());}
     | TOK_POINT TOK_LEFTPAREN number TOK_COMMA number TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QPoint($3->toFloat(), $5->toFloat());
       }
     ;

pointF: TOK_POINTF TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QPointF());}
      | TOK_POINTF TOK_LEFTPAREN point TOK_RIGHTPAREN {
            $$ = new QVariant();
            *$$ = QPointF($3->toPoint());
        }
      | TOK_POINTF TOK_LEFTPAREN number TOK_COMMA number TOK_RIGHTPAREN {
            $$ = new QVariant();
            *$$ = QPointF($3->toFloat(), $5->toFloat());
        }
      ;

size: TOK_SIZE TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QSize());}
    | TOK_SIZE TOK_LEFTPAREN number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QSize($3->toFloat(), $5->toFloat());
      }
    ;

sizeF: TOK_SIZEF TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QSizeF());}
     | TOK_SIZEF TOK_LEFTPAREN size TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QSizeF($3->toSize());
       }
     | TOK_SIZEF TOK_LEFTPAREN number TOK_COMMA number TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QSizeF($3->toFloat(), $5->toFloat());
       }
     ;

dateTime: TOK_DATETIME TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QDateTime());}
        | TOK_DATETIME TOK_LEFTPAREN date TOK_RIGHTPAREN {
              $$ = new QVariant();
              *$$ = QDateTime($3->toDate());
          }
        | TOK_DATETIME TOK_LEFTPAREN date TOK_COMMA time TOK_RIGHTPAREN {
              $$ = new QVariant();
              *$$ = QDateTime($3->toDate(), $5->toTime());
          }
        ;

date: TOK_DATE TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QDate());}
    | TOK_DATE TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QDate($3->toFloat(), $5->toFloat(), $7->toFloat());
      }
    ;

time: TOK_TIME TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QTime());}
    | TOK_TIME TOK_LEFTPAREN number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QTime($3->toFloat(), $5->toFloat());
      }
    | TOK_TIME TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QTime($3->toFloat(), $5->toFloat(), $7->toFloat());
      }
    | TOK_TIME TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
          $$ = new QVariant();
          *$$ = QTime($3->toFloat(), $5->toFloat(), $7->toFloat(), $9->toFloat());
      }
    ;

color: TOK_COLOR TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QColor());}
     | TOK_COLOR TOK_LEFTPAREN TOK_STRING TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QColor($3->toString());
       }
     | TOK_COLOR TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QColor($3->toFloat(), $5->toFloat(), $7->toFloat());
       }
     | TOK_COLOR TOK_LEFTPAREN number TOK_COMMA number TOK_COMMA number TOK_COMMA number TOK_RIGHTPAREN {
           $$ = new QVariant();
           *$$ = QColor($3->toFloat(), $5->toFloat(), $7->toFloat(), $9->toFloat());
       }
     ;

bytes: TOK_BYTES TOK_STRING  {
           $$ = new QVariant();
           *$$ = $2->toString().toUtf8();
       }
     ;

url: TOK_URL TOK_LEFTPAREN TOK_RIGHTPAREN {$$ = new QVariant(QUrl());}
   | TOK_URL TOK_LEFTPAREN TOK_STRING TOK_RIGHTPAREN {
         $$ = new QVariant();
         *$$ = QUrl($3->toString());
     }
   ;

variantList: TOK_LEFTBRACKET TOK_RIGHTBRACKET {$$ = new QVariant(QVariantList());}
           | TOK_LEFTBRACKET variantListItems TOK_RIGHTBRACKET {
                 $$ = new QVariant();
                 *$$ = $2->toList();
             }
           ;

variantListItems: variant {
                      $$ = new QVariant();

                      QVariantList variantList;

                      variantList << *$1;

                      *$$ = variantList;
                  }
                | variantListItems TOK_COMMA variant {
                      $$ = new QVariant();

                      QVariantList variantList($1->toList());

                      variantList << *$3;

                      *$$ = variantList;
                  }
                ;

variantMap: TOK_LEFTCURLYBRACKET TOK_RIGHTCURLYBRACKET {$$ = new QVariant(QVariantMap());}
          | TOK_LEFTCURLYBRACKET variantMapItems TOK_RIGHTCURLYBRACKET {
                $$ = new QVariant();
                *$$ = $2->toMap();
            }
          ;

variantMapItems: variantMapPair {
                     $$ = new QVariant();

                     QVariantMap variantMap;
                     QVariantList pair = $1->toList();

                     variantMap[pair[0].toString()] = pair[1];

                     *$$ = variantMap;
                 }
               | variantMapItems TOK_COMMA variantMapPair {
                     $$ = new QVariant();

                     QVariantMap variantMap($1->toMap());
                     QVariantList pair = $3->toList();

                     variantMap[pair[0].toString()] = pair[1];

                     *$$ = variantMap;
                 }
               ;

variantMapPair: TOK_STRING TOK_COLON variant {
                    $$ = new QVariant();

                    QVariantList variantList;

                    variantList << $1->toString() << *$3;

                    *$$ = variantList;
                }
              ;

number: TOK_INTIGER
      | TOK_FLOAT
      ;

%%

void yyerror(const char *s)
{
    qDebug() << "error:" << s;
}
