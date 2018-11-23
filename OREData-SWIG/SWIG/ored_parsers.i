
/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef ored_parsers_i
#define ored_parsers_i

%include indexes.i
%include inflation.i
%include termstructures.i
%include qle_indexes.i
%include ored_conventions.i

%{
using QuantLib::YieldTermStructure;
using QuantLib::ZeroInflationTermStructure;
using QuantLib::Handle;
using QuantLib::Index;
using QuantLib::Option;
using QuantLib::Exercise;
using QuantLib::Settlement;
using QuantLib::Position;
using QuantLib::Compounding;
using QuantLib::Frequency;
using QuantLib::DateGeneration;
using QuantLib::Currency;
using QuantLib::DayCounter;
using QuantLib::BusinessDayConvention;
using QuantLib::Period;
using QuantLib::Calendar;
using QuantLib::Date;

using ore::data::Conventions;
using ore::data::IRSwapConvention;

using ore::data::parseIborIndex;
using ore::data::parseSwapIndex;
using ore::data::parseZeroInflationIndex;
using ore::data::parseFxIndex;
using ore::data::parseIndex;
using ore::data::parseCalendar;
using ore::data::parsePeriod;
using ore::data::parseOptionType;
using ore::data::parseExerciseType;
using ore::data::parseSettlementType;
using ore::data::parsePositionType;
using ore::data::parseCompounding;
using ore::data::parseFrequency;
using ore::data::parseDateGenerationRule;
using ore::data::parseCurrency;
using ore::data::parseDayCounter;
using ore::data::parseBusinessDayConvention;
using ore::data::parseDate;
%}

IborIndexPtr parseIborIndex(const std::string& s,
    const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
    
SwapIndexPtr parseSwapIndex(const std::string& s, 
    const Handle<YieldTermStructure>& forwarding = Handle<YieldTermStructure>(),
    const Handle<YieldTermStructure>& discounting = Handle<YieldTermStructure>(),
    boost::shared_ptr<IRSwapConvention> convention = boost::shared_ptr<IRSwapConvention>());

boost::shared_ptr<Index> parseIndex(const std::string& s,
    const Conventions& conventions = Conventions());
    
ZeroInflationIndexPtr parseZeroInflationIndex(const std::string& s, bool isInterpolated = false,
    const Handle<ZeroInflationTermStructure>& h = Handle<ZeroInflationTermStructure>());
    
FxIndexPtr parseFxIndex(const std::string& s);

QuantLib::Calendar parseCalendar(const std::string& s);
QuantLib::Period parsePeriod(const std::string& s);
QuantLib::BusinessDayConvention parseBusinessDayConvention(const std::string& s);
QuantLib::DayCounter parseDayCounter(const std::string& s);
QuantLib::Currency parseCurrency(const std::string& s);
QuantLib::DateGeneration::Rule parseDateGenerationRule(const std::string& s);
QuantLib::Frequency parseFrequency(const std::string& s);
QuantLib::Compounding parseCompounding(const std::string& s);
QuantLib::Position::Type parsePositionType(const std::string& s);
QuantLib::Settlement::Type parseSettlementType(const std::string& s);
QuantLib::Exercise::Type parseExerciseType(const std::string& s);
QuantLib::Option::Type parseOptionType(const std::string& s);
QuantLib::Date parseDate(const std::string& s);

#endif