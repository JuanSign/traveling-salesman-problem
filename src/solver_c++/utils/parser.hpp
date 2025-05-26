#ifndef __PARSER__
#define __PARSER__

#include <string>
#include <vector>

class PARSER
{
public:
    static std::vector<std::vector<double>> ParseProblem(const std::string &path);
};

#endif