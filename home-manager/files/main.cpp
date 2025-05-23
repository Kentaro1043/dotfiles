<%!
    import json
    import os
    import platform
    import shutil
    from logging import getLogger

    import onlinejudge_template.generator.cplusplus as cplusplus
    import onlinejudge_template.generator.about as about
    import onlinejudge_template.generator.hook as hook
%>\
<%
    logger = getLogger(__name__)
    data["config"]["rep_macro"] = "rep"
    data["config"]["using_namespace_std"] = True
    data["config"]["long_long_int"] = "ll"
    hook.register_filter_command(["clang-format"], data=data)
%>\
#include <bits/stdc++.h>
// #include <atcoder/fenwicktree>
// #include <atcoder/segtree>
// #include <atcoder/lazysegtree>
// #include <atcoder/string>
// #include <atcoder/math>
// #include <atcoder/convolution>
// c#include <atcoder/modint>
// #include <atcoder/dsu>
// #include <atcoder/maxflow>
// #include <atcoder/mincostflow>
// #include <atcoder/scc>
// #include <atcoder/twosat>
// #include <boost/multiprecision/cpp_int.hpp>
#define rep(i, n) for (int i = 0; i < (int)(n); i++)
#define rep3(i, m, n) for (int i = m; i < (int)(n); i++)
#define all(x) (x).begin(), (x).end()
using namespace std;
// using namespace atcoder;
// using namespace boost::multiprecision;
typedef long long ll;
// typedef modint1000000007 mint;
// typedef modint998244353 mint;

${cplusplus.declare_constants(data)}
${cplusplus.return_type(data)} solve(${cplusplus.formal_arguments(data)})
{
    // TOOD
}

int main(void)
{
${cplusplus.read_input(data)}
    auto ${cplusplus.return_value(data)} = solve(${cplusplus.actual_arguments(data)});
${cplusplus.write_output(data)}
    return 0;
}
