#ifndef ISHAPES_H
#define ISHAPES_H

#include <QObject>

const int WIDTH = 4;
const int LENGTH = 4;
enum rotateShape {UPRIGHT, RIGHT, UPSIDE_DOWN, LEFT};
struct shapeStruct{
    bool upRight[WIDTH][LENGTH];
    bool right[WIDTH][LENGTH];
    bool upsideDown[WIDTH][LENGTH];
    bool left[WIDTH][LENGTH];
};

class ishapes : public QObject
{
    Q_OBJECT

public:
    ishapes();
    bool * getRotateState();

signals:
    void test();

public slots:
   virtual void rotate() = 0;  //rotate shape

protected:
   shapeStruct m_shapeStruct;
   bool m_rotateState[WIDTH][LENGTH];
   rotateShape rotateState;
   QString m_color;
};

#endif // ISHAPES_H
