// Copyright (c) 2011-2014 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef VEKTORCOIN_QT_VEKTORCOINADDRESSVALIDATOR_H
#define VEKTORCOIN_QT_VEKTORCOINADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class VEKTORCOINAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit VEKTORCOINAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** VEKTORCOIN address widget validator, checks for a valid vektorcoin address.
 */
class VEKTORCOINAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit VEKTORCOINAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // VEKTORCOIN_QT_VEKTORCOINADDRESSVALIDATOR_H
