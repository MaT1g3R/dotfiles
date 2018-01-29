from argparse import ArgumentParser
from scipy.stats import norm


def probability(s):
    res = float(s)
    if 0 <= res <= 1:
        return res
    raise ValueError("Probaility must be between 0 and 1")


def digits(s):
    res = int(s)
    if res < 1:
        raise ValueError('There must be at least one digit.')
    return res


def zscore(prob, type_):
    if type_ == 'lower':
        return norm.ppf(prob)
    elif type_ == 'middle':
        return norm.ppf(1 - (1 - prob)/2)
    else:
        return norm.ppf(1 - prob)


def main():
    parser = ArgumentParser(description='Look up z score.')
    parser.add_argument('p', help='The desired p value', type=probability)
    parser.add_argument('-T', '--type', help='Type of probability',
                        choices=['upper', 'middle', 'lower'], required=True)
    parser.add_argument('-D', '--digits',
                        help='The number of decimal points to round to',
                        type=digits, default=4)
    args = parser.parse_args()
    res = zscore(args.p, args.type)
    print(format(res, f'.{args.digits}f'))


if __name__ == '__main__':
    main()
