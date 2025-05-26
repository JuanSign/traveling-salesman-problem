#include "parser.hpp"

#include <fstream>
#include <sstream>
#include <iostream>
#include <cmath>

struct City
{
    int index;
    double x, y;
};

double EuclideanDistance(const City &a, const City &b)
{
    double dx = a.x - b.x;
    double dy = a.y - b.y;
    return std::sqrt(dx * dx + dy * dy);
}

std::vector<std::vector<double>> parseCoordinates(std::ifstream &file)
{
    std::string line;
    std::vector<City> cities;

    while (std::getline(file, line))
    {
        if (line == "EOF")
            break;
        std::istringstream iss(line);
        City city;
        iss >> city.index >> city.x >> city.y;
        cities.push_back(city);
    }

    int n = cities.size();
    std::vector<std::vector<double>> dist(n, std::vector<double>(n, 0.0));

    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j)
            if (i != j)
                dist[i][j] = EuclideanDistance(cities[i], cities[j]);

    return dist;
}

std::vector<std::vector<double>> parseExplicitMatrix(std::ifstream &file, int dimension, const std::string &format)
{
    std::vector<std::vector<double>> dist(dimension, std::vector<double>(dimension, 0.0));
    std::vector<double> values;
    double val;

    while (file >> val)
        values.push_back(val);

    int idx = 0;

    if (format == "FULL_MATRIX")
    {
        for (int i = 0; i < dimension; ++i)
            for (int j = 0; j < dimension; ++j)
                dist[i][j] = values[idx++];
    }
    else if (format == "UPPER_ROW")
    {
        for (int i = 0; i < dimension; ++i)
            for (int j = i + 1; j < dimension; ++j)
            {
                dist[i][j] = values[idx];
                dist[j][i] = values[idx];
                idx++;
            }
    }
    else
    {
        std::cerr << "Unsupported EDGE_WEIGHT_FORMAT: " << format << std::endl;
    }

    return dist;
}

std::vector<std::vector<double>> PARSER::ParseProblem(const std::string &path)
{
    std::ifstream file(path);
    std::string line;
    std::string edge_weight_type;
    std::string edge_weight_format;
    int dimension = 0;

    if (!file.is_open())
    {
        std::cerr << "Unable to open file: " << path << std::endl;
        return {};
    }

    while (std::getline(file, line))
    {
        if (line.rfind("DIMENSION", 0) == 0)
            dimension = std::stoi(line.substr(line.find(":") + 1));
        else if (line.rfind("EDGE_WEIGHT_TYPE", 0) == 0)
            edge_weight_type = line.substr(line.find(":") + 1);
        else if (line.rfind("EDGE_WEIGHT_FORMAT", 0) == 0)
            edge_weight_format = line.substr(line.find(":") + 1);
        else if (line == "NODE_COORD_SECTION")
        {
            return parseCoordinates(file);
        }
        else if (line == "EDGE_WEIGHT_SECTION")
        {
            auto trim = [](std::string &s)
            {
                s.erase(0, s.find_first_not_of(" \t\r\n"));
                s.erase(s.find_last_not_of(" \t\r\n") + 1);
            };

            trim(edge_weight_type);
            trim(edge_weight_format);

            if (edge_weight_type == "EXPLICIT")
                return parseExplicitMatrix(file, dimension, edge_weight_format);
        }
    }

    std::cerr << "Unrecognized or unsupported TSP format." << std::endl;
    return {};
}
