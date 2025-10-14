#! /usr/bin/env python3
from diagrams import Diagram, Edge, Cluster
from diagrams.azure.network import Firewall, Subnets, DNSZones, PublicIpAddresses, ServiceEndpointPolicies
from diagrams.azure.general import Resource, Tags
from diagrams.azure.web import AppServiceDomains

graph_attr = {
    "splines": "curve",
    "concentrate": "true",
    "rankdir": "TB",
    "ranksep": "2",
    "label": "Automatically generated diagram: 03/15/2025 06:10:25",
    "fontsize": "25",
          }

node_attr = {
    "fontsize": "15",
    "imagepos": "tc",
    "labelloc": "b",
    "fixedsize": "shape",
          }
with Diagram("platformRuleCollectionGroup", graph_attr=graph_attr, node_attr=node_attr, show=False, direction="TB"):
    afw = Firewall("\n\nAzure Firewall")


    with Cluster("platformRuleCollectionGroup - Rule Collection Group",  graph_attr={"bgcolor": "#e0effa", "fontsize": "50", "penwidth": "3", "style": "solid", "labeljust": "c"}):

        with Cluster("platform_activeDirectory_network - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            ipg_azuresuper_et_ = Subnets("\n\nipg-azureSupernet (10.204.0.0/23, 10.204.2.0/23, 10.204.4.0/23)")
            _variables_azureadds_ = ServiceEndpointPolicies("\n\n[variables('_1.ipGroups').azureADDS]")
            ipg_azuresuper_et_ >> Edge(label="Any/53, 88, 123, 135, 137-139, 389, 445, 464, 636, 3268, 3269, 5722, 9389, 49152-65535", minlen="1", tailport="s", headport="n") >> _variables_azureadds_
            ipg_azureadds_ = Subnets("\n\nipg-azureADDS (10.204.4.0/24)")
            ipg_azureadds_ >> Edge(label="Any/53, 88, 123, 135, 137-139, 389, 445, 464, 636, 3268, 3269, 5722, 9389, 49152-65535", minlen="1", tailport="s", headport="n") >> ipg_azuresuper_et_
            ipg_o_premisesadds_ = Subnets("\n\nipg-onPremisesADDS (10.0.0.0/24)")
            ipg_azuresuper_et_ >> Edge(label="Any/53, 88, 123, 135, 137-139, 389, 445, 464, 636, 3268, 3269, 5722, 9389, 49152-65535", minlen="1", tailport="s", headport="n") >> ipg_o_premisesadds_
            ipg_o_premisesadds_ >> Edge(label="Any/53, 88, 123, 135, 137-139, 389, 445, 464, 636, 3268, 3269, 5722, 9389, 49152-65535", minlen="1", tailport="s", headport="n") >> ipg_azuresuper_et_
            ipg_o_premisesadds_ >> Edge(label="Any/53, 88, 123, 135, 137-139, 389, 445, 464, 636, 3268, 3269, 5722, 9389, 49152-65535", minlen="1", tailport="s", headport="n") >> ipg_azureadds_

        with Cluster("platform_centralRunners_application - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            ipg_azurece_tralru_ers_ = Subnets("\n\nipg-azureCentralRunners (10.204.3.0/27)")
            google_com_google_com = DNSZones("\n\ngoogle.com, *.google.com")
            ipg_azurece_tralru_ers_ >> Edge(label="targetFqdns/Https:443", minlen="1", tailport="s", headport="n") >> google_com_google_com
            archive_ubu_tu_com_security_ubu_tu_com = DNSZones("\n\narchive.ubuntu.com, security.ubuntu.com")
            ipg_azurece_tralru_ers_ >> Edge(label="targetFqdns/Https:443, Http:80", minlen="1", tailport="s", headport="n") >> archive_ubu_tu_com_security_ubu_tu_com

        with Cluster("platform_centralRunners_network - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            ipg_azurece_tralru_ers_ >> Edge(label="TCP/443", minlen="1", tailport="s", headport="n") >> ipg_azuresuper_et_
            ips_4_175_114_51_32_20_102_35_120_32_4_175_114_43_32_20_72_125_48_32_20_19_5_100_32_20_7_92_46_32_20_232_252_48_32_52_186_44_51_32_20_22_98_201_32_20_246_184_240_32_20_96_133_71_32_20_253_2_203_32_20_102_39_220_32_20_81_127_181_32_52_148_30_208_32_20_14_42_190_32_20_85_159_192_32_52_224_205_173_32_20_118_176_156_32_20_236_207_188_32_20_242_161_191_32_20_166_216_139_32_20_253_126_26_32_52_152_245_137_32_40_118_236_116_32_20_185_75_138_32_20_96_226_211_32_52_167_78_33_32_20_105_13_142_32_20_253_95_3_32_20_221_96_90_32_51_138_235_85_32_52_186_47_208_32_20_7_220_66_32_20_75_4_210_32_20_120_75_171_32_20_98_183_48_32_20_84_200_15_32_20_14_235_135_32_20_10_226_54_32_20_22_166_15_32_20_65_21_88_32_20_102_36_236_32_20_124_56_57_32_20_94_100_174_32_20_102_166_33_32_20_31_193_160_32_20_232_77_7_32_20_102_38_122_32_20_102_39_57_32_20_85_108_33_32_40_88_240_168_32_20_69_187_19_32_20_246_192_124_32_20_4_161_108_32_20_22_22_84_32_20_1_250_47_32_20_237_33_78_32_20_242_179_206_32_40_88_239_133_32_20_121_247_125_32_20_106_107_180_32_20_22_118_40_32_20_15_240_48_32_20_84_218_150_32 = PublicIpAddresses("4.175.114.51/32,\n20.102.35.120/32,\n4.175.114.43/32,\n20.72.125.48/32,\n20.19.5.100/32,\n20.7.92.46/32,\n20.232.252.48/32,\n52.186.44.51/32,\n20.22.98.201/32,\n20.246.184.240/32,\n20.96.133.71/32,\n2...")
            ipg_azurece_tralru_ers_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> ips_4_175_114_51_32_20_102_35_120_32_4_175_114_43_32_20_72_125_48_32_20_19_5_100_32_20_7_92_46_32_20_232_252_48_32_52_186_44_51_32_20_22_98_201_32_20_246_184_240_32_20_96_133_71_32_20_253_2_203_32_20_102_39_220_32_20_81_127_181_32_52_148_30_208_32_20_14_42_190_32_20_85_159_192_32_52_224_205_173_32_20_118_176_156_32_20_236_207_188_32_20_242_161_191_32_20_166_216_139_32_20_253_126_26_32_52_152_245_137_32_40_118_236_116_32_20_185_75_138_32_20_96_226_211_32_52_167_78_33_32_20_105_13_142_32_20_253_95_3_32_20_221_96_90_32_51_138_235_85_32_52_186_47_208_32_20_7_220_66_32_20_75_4_210_32_20_120_75_171_32_20_98_183_48_32_20_84_200_15_32_20_14_235_135_32_20_10_226_54_32_20_22_166_15_32_20_65_21_88_32_20_102_36_236_32_20_124_56_57_32_20_94_100_174_32_20_102_166_33_32_20_31_193_160_32_20_232_77_7_32_20_102_38_122_32_20_102_39_57_32_20_85_108_33_32_40_88_240_168_32_20_69_187_19_32_20_246_192_124_32_20_4_161_108_32_20_22_22_84_32_20_1_250_47_32_20_237_33_78_32_20_242_179_206_32_40_88_239_133_32_20_121_247_125_32_20_106_107_180_32_20_22_118_40_32_20_15_240_48_32_20_84_218_150_32
            ips_140_82_112_0_20_143_55_64_0_20_185_199_108_0_22_192_30_252_0_22_20_175_192_146_32_20_175_192_147_32_20_175_192_149_32_20_175_192_150_32_20_199_39_227_32_20_199_39_228_32_20_199_39_231_32_20_199_39_232_32_20_200_245_241_32_20_200_245_245_32_20_200_245_246_32_20_200_245_247_32_20_200_245_248_32_20_201_28_144_32_20_201_28_148_32_20_201_28_149_32_20_201_28_151_32_20_201_28_152_32_20_205_243_160_32_20_205_243_164_32_20_205_243_165_32_20_205_243_166_32_20_205_243_168_32_20_207_73_82_32_20_207_73_83_32_20_207_73_85_32_20_207_73_86_32_20_207_73_88_32_20_217_135_1_32_20_233_83_145_32_20_233_83_146_32_20_233_83_147_32_20_233_83_149_32_20_233_83_150_32_20_248_137_48_32_20_248_137_49_32_20_248_137_50_32_20_248_137_52_32_20_248_137_55_32_20_26_156_215_32_20_26_156_216_32_20_26_156_211_32_20_27_177_113_32_20_27_177_114_32_20_27_177_116_32_20_27_177_117_32_20_27_177_118_32_20_29_134_17_32_20_29_134_18_32_20_29_134_19_32_20_29_134_23_32_20_29_134_24_32_20_87_245_0_32_20_87_245_1_32_20_87_245_4_32_20_87_245_6_32_20_87_245_7_32_4_208_26_196_32_4_208_26_197_32_4_208_26_198_32_4_208_26_199_32_4_208_26_200_32_4_225_11_196_32_4_237_22_32_32 = PublicIpAddresses("140.82.112.0/20,\n143.55.64.0/20,\n185.199.108.0/22,\n192.30.252.0/22,\n20.175.192.146/32,\n20.175.192.147/32,\n20.175.192.149/32,\n20.175.192.150/32,\n20.199.39.227/32,\n20.199.39.228/32,\n20.199.39....")
            ipg_azurece_tralru_ers_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> ips_140_82_112_0_20_143_55_64_0_20_185_199_108_0_22_192_30_252_0_22_20_175_192_146_32_20_175_192_147_32_20_175_192_149_32_20_175_192_150_32_20_199_39_227_32_20_199_39_228_32_20_199_39_231_32_20_199_39_232_32_20_200_245_241_32_20_200_245_245_32_20_200_245_246_32_20_200_245_247_32_20_200_245_248_32_20_201_28_144_32_20_201_28_148_32_20_201_28_149_32_20_201_28_151_32_20_201_28_152_32_20_205_243_160_32_20_205_243_164_32_20_205_243_165_32_20_205_243_166_32_20_205_243_168_32_20_207_73_82_32_20_207_73_83_32_20_207_73_85_32_20_207_73_86_32_20_207_73_88_32_20_217_135_1_32_20_233_83_145_32_20_233_83_146_32_20_233_83_147_32_20_233_83_149_32_20_233_83_150_32_20_248_137_48_32_20_248_137_49_32_20_248_137_50_32_20_248_137_52_32_20_248_137_55_32_20_26_156_215_32_20_26_156_216_32_20_26_156_211_32_20_27_177_113_32_20_27_177_114_32_20_27_177_116_32_20_27_177_117_32_20_27_177_118_32_20_29_134_17_32_20_29_134_18_32_20_29_134_19_32_20_29_134_23_32_20_29_134_24_32_20_87_245_0_32_20_87_245_1_32_20_87_245_4_32_20_87_245_6_32_20_87_245_7_32_4_208_26_196_32_4_208_26_197_32_4_208_26_198_32_4_208_26_199_32_4_208_26_200_32_4_225_11_196_32_4_237_22_32_32
            storage = ServiceEndpointPolicies("\n\nStorage")
            ipg_azurece_tralru_ers_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> storage

        with Cluster("platform_core_application - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            wi_dowsupdate = ServiceEndpointPolicies("\n\nWindowsUpdate")
            ipg_azuresuper_et_ >> Edge(label="fqdnTags/Http:80, Https:443", minlen="1", tailport="s", headport="n") >> wi_dowsupdate
            _security_ubu_tu_com_archive_ubu_tu_com_security_ubu_tu_com_archive_ubu_tu_com = DNSZones("*.security.ubuntu.com,\n*.archive.ubuntu.com,\nsecurity.ubuntu.com,\narchive.ubuntu.com")
            ipg_azuresuper_et_ >> Edge(label="targetFqdns/Http:80, Https:443", minlen="1", tailport="s", headport="n") >> _security_ubu_tu_com_archive_ubu_tu_com_security_ubu_tu_com_archive_ubu_tu_com
            azurebackup = ServiceEndpointPolicies("\n\nAzureBackup")
            ipg_azuresuper_et_ >> Edge(label="fqdnTags/Http:80, Https:443", minlen="1", tailport="s", headport="n") >> azurebackup
            wi_dowsdiag_ostics = ServiceEndpointPolicies("\n\nWindowsDiagnostics")
            ipg_azuresuper_et_ >> Edge(label="fqdnTags/Http:80, Https:443", minlen="1", tailport="s", headport="n") >> wi_dowsdiag_ostics

        with Cluster("platform_core_network - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            azurecloud_australiaeast = ServiceEndpointPolicies("\n\nAzureCloud.AustraliaEast")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> azurecloud_australiaeast
            azureactivedirectory = ServiceEndpointPolicies("\n\nAzureActiveDirectory")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> azureactivedirectory
            azuremo_itor = ServiceEndpointPolicies("\n\nAzureMonitor")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> azuremo_itor
            microsoftdefe_derfore_dpoi_t = ServiceEndpointPolicies("\n\nMicrosoftDefenderForEndpoint")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> microsoftdefe_derfore_dpoi_t
            azurearci_frastructure = ServiceEndpointPolicies("\n\nAzureArcInfrastructure")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> azurearci_frastructure
            servicebus = ServiceEndpointPolicies("\n\nServiceBus")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> servicebus
            powerbi = ServiceEndpointPolicies("\n\nPowerBI")
            ipg_azuresuper_et_ >> Edge(label="TCP/*", minlen="1", tailport="s", headport="n") >> powerbi
            ipg_azuresuper_et_ >> Edge(label="ICMP/*", minlen="1", tailport="s", headport="n") >> ipg_azuresuper_et_
            kms_core_wi_dows_et_azkms_core_wi_dows_et = DNSZones("\n\nkms.core.windows.net, azkms.core.windows.net")
            ipg_azuresuper_et_ >> Edge(label="TCP/1688", minlen="1", tailport="s", headport="n") >> kms_core_wi_dows_et_azkms_core_wi_dows_et

        with Cluster("platform_externalWeb_application - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            ipg_azureplatmgmtjumphost_ = Subnets("\n\nipg-azurePlatMgmtJumpHost (10.204.2.0/24)")
            _ = DNSZones("\n\n*")
            ipg_azureplatmgmtjumphost_ >> Edge(label="targetFqdns/Http:80, Https:443", minlen="1", tailport="s", headport="n") >> _

        with Cluster("platform_remoteAccess_network - Rule Collection", graph_attr={"bgcolor": "#f2f8fc", "style": "dashed", "penwidth": "3", "fontsize": "30", "labeljust": "c"}):
            ipg_azurebastio_ = Subnets("\n\nipg-azureBastion (10.204.3.32/27)")
            ipg_azurebastio_ >> Edge(label="TCP, UDP/3389, 22", minlen="1", tailport="s", headport="n") >> ipg_azureplatmgmtjumphost_
    afw >> Cluster("platformRuleCollectionGroup")
