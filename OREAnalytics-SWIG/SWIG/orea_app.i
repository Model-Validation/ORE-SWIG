/*
 Copyright (C) 2018, 2020 Quaternion Risk Management Ltd
 All rights reserved.

 This file is part of ORE, a free-software/open-source library
 for transparent pricing and risk analysis - http://opensourcerisk.org

 ORE is free software: you can redistribute it and/or modify it
 under the terms of the Modified BSD License.  You should have received a
 copy of the license along with this program.
 The license is also available online at <http://opensourcerisk.org>

 This program is distributed on the basis that it will form a useful
 contribution to risk analytics and model standardisation, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the license for more details.
*/

#ifndef orea_app_i
#define orea_app_i

%include ored_market.i
// %include vectors.i
// %include ratehelpers.i

// %include <std_vector.i>
// %include <std_map.i>
// %include <std_set.i>
// %include <std_string.i>

%{
using ore::analytics::Parameters;
using ore::analytics::OREApp;
// using ore::data::YieldCurveCalibrationInfo;
// using ore::data::MarketObject;
// using QuantLib::RateHelper;
%}

// ORE Analytics

// namespace std {
//   %template(NodesMap) map<string, vector<pair<Date,double> > >; 
//   %template(YCCaliInfo) map<string, ext::shared_ptr<YieldCurveCalibrationInfo> >;
//   // %template(MarketObjetSet) set<MarketObject>;
// };

%shared_ptr(Parameters)
class Parameters {
  public:
    Parameters();
    void clear();
    void fromFile(const std::string& name);
    bool hasGroup(const std::string& groupName) const;
    bool has(const std::string& groupName, const std::string& paramName) const;
    // void setAsof(const std::string& dateStr);
    std::string get(const std::string& groupName, const std::string& paramName) const;
    //TODO: add this function to ORE, then add here
    //void add(const std::string& groupName, const std::string& paramName, const std::string& paramValue);
};

// %shared_ptr(YieldCurveCalibrationInfo)
// class YieldCurveCalibrationInfo {
// 	public:
//     YieldCurveCalibrationInfo();
//     std::string& dayCounter;
//     std::string currency;
//     std::string interpolationMethod;
//     std::string interpolationVariable;

//     std::vector<QuantLib::Date> pillarDates;
//     std::vector<double> zeroRates;
//     std::vector<double> discountFactors;
//     std::vector<double> times;
//     std::vector< ext::shared_ptr<RateHelper> > instruments;
// };


%shared_ptr(OREApp)
class OREApp {
  public:
    OREApp(const ext::shared_ptr<Parameters>& p, std::ostream& out = std::cout);
    // ~OREApp();

    int run();

    void buildMarket(const std::string& todaysMarketXML = "", const std::string& curveConfigXML = "",
                     const std::string& conventionsXML = "",
                     const std::vector<std::string>& marketData = std::vector<std::string>(),
                     const std::vector<std::string>& fixingData = std::vector<std::string>());

    ext::shared_ptr<MarketImpl> getMarket() const;
    // void writeReport(const std::string& report);
//    const std::vector<std::pair<QuantLib::Date, QuantLib::Rate>> discountCurveNodes() const;
    // std::map<std::string, ext::shared_ptr<YieldCurveCalibrationInfo> >  yieldCurveCalibrationInfo() const;

    // std::map<std::string, std::vector< std::pair<QuantLib::Date, double> > > discountCurveNodes() const;

    ext::shared_ptr<ore::data::EngineFactory> buildEngineFactoryFromXMLString(
        const ext::shared_ptr<MarketImpl>& marketImpl,
        const std::string& pricingEngineXML,
        const bool generateAdditionalResults = false);
};

#endif
