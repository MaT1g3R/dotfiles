#ifndef WITH_H
#define WITH_H

#define WITH(enter, exit) for(int _ = ((enter), 0); _ < 1; (exit), ++_)
#define WITH_ENTER(enter) for(int _ = ((enter), 0); _ < 1; ++_)
#define WITH_EXIT(exit) for(int _ = 0; _ < 1; (exit), ++_)

#endif /* WITH_H */
