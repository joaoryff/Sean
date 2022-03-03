<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" >
	<xsl:output method="html" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
	<xsl:key name="suite-ref" match="planAndSuites/testPlan/suiteHierarchy//suite" use="@id"/>
	<xsl:key name="suite-ref2" match="planAndSuites/testSuites//testSuite" use="@id"/>
	<xsl:template match="/">
		<xsl:for-each select="planAndSuites" >
			<div id="exported-data">
				<style type="text/css">           .heading {           font-size: 24px;           font-family: 'Segoe UI Light';           font-weight: normal;           margin-top: 15px;           margin-bottom: 15px;           background-color: white;           padding: 3px; color: #77a22f;          }                      .test-case-heading{           font-size: 20px; color: #F8981D;          }            .colored-table th{           background-color: white;           }            .table-row-even {           background-color: white;           }            .configuration-variable-style{           padding-right: 2px;           }            a{           color: white;           cursor: pointer;      }            table{           word-break: break-all; \t        line-height:1;           }           .tab{           font-size: 16px;           font-family:'Segoe UI';           margin-top: 10px;           margin-bottom: 5px;           }            hr{           margin-top: 0px;           }            .sub-tab{           margin-top: 10px;           font-size: 11px;           font-family: 'Segoe UI';           font-weight: bold;           }            body, .body-text {           font-size: 13px;           font-family: 'Segoe UI';           font-weight: normal;           }            .table-style{           width: 100%;           }            .params-table td, .params-table th{           padding-right: 20px;           }                      .shared-param-mapping th{           font-weight: bold;           background-color: white;           }            .property-name, th{           color: white;           font-weight: normal;           }            .property-name{           color: white;           font-weight: normal;           min-width: 150px;           }            th{           text-align: left;           }            tr{           vertical-align: top;           font-size: 13px;           font-family: 'Segoe UI';           font-weight: normal;           }            span.property-name{           padding: 3px;           display: inline-block;           }            table td,           td div{           border-spacing: 0px;           display: table-cell;           vertical-align:top;           }            td div p{           vertical-align:top;           margin:0px;           }                      .test-step-attachment{           display:block;           }                      .avoid-page-break{           page-break-inside: avoid;           }          </style>
				<xsl:for-each select="testPlan">
					<xsl:for-each select="suiteHierarchy">
						<div class="body-text">
							<xsl:call-template name="suiteHierarchy">
								<xsl:with-param name="count">
									<xsl:value-of select="0"/>
								</xsl:with-param>
							</xsl:call-template>
						</div>
					</xsl:for-each>
					<xsl:for-each select="configurations" />
				</xsl:for-each>
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="suiteHierarchy">
		<xsl:param name="count" select="0"/>
		<xsl:for-each select="suite">
			<xsl:call-template name="loop">
				<xsl:with-param name="totalCount">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>       
			<div class="heading" _locID="TestSuite">
          <xsl:value-of select="@title"/>   
			</div>
            <xsl:comment>  Legacy code    
                (ID: <xsl:value-of select="@id"/>)
                (Parent suite: <xsl:value-of select="key('suite-ref',@id)/parent::suite/@id"/>) 
                (GrandParent suite: <xsl:value-of select="key('suite-ref',@id)/parent::*/parent::suite/@id"/>)
                -- Number of test cases: <xsl:value-of select="key('suite-ref2', @id)/child::testCases/@count"/>
                -- ID of test cases: <xsl:value-of select="key('suite-ref2', @id)/child::*/child::testCase/@id"/>
                <xsl:for-each select="key('suite-ref2', @id)/child::*/child::testCase">           
                    <br/> 
                    <span style="margin-left:70px;font-size:10pt">
                        TestCase: <xsl:value-of select="@id"/>  - <xsl:value-of select="@title"/>
                        <br /> 
                    </span>
                    <xsl:apply-templates select="testSteps"/>
                </xsl:for-each>     
            </xsl:comment>      

			<xsl:for-each select="key('suite-ref2',@id)/child::testCases">
				<xsl:apply-templates  select="testCase" />
			</xsl:for-each>
			<br />  
			<xsl:call-template name="suiteHierarchy">
				<xsl:with-param name="count">
					<xsl:value-of select="$count+4"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
    
	<xsl:template name="loop">
		<xsl:param name="count" select="0"/>
		<xsl:param name="totalCount"/>
		<xsl:if test="($count &lt; $totalCount)">
			<xsl:call-template name="loop">
				<xsl:with-param name="count">
					<xsl:value-of select="$count + 1"/>
				</xsl:with-param>
				<xsl:with-param name="totalCount">
					<xsl:value-of select="$totalCount"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="testSteps">
		<xsl:for-each select="testStep">
			<span style="margin-left:90px;font-size:8pt">
				<xsl:value-of select="@index"/>
				<xsl:value-of select="testStepAction/*"/>
				<br/>   
			</span>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="testCase">
		<div class ="test-case-heading" _locID="TestCase">
			<xsl:value-of select="@title"/>
		</div>
		<xsl:for-each select="properties">
			<xsl:if test="*">
				<div class="sub-tab" _locID="Properties">
            PROPERTIES                       <br/>
				</div>
				<xsl:apply-templates select = "."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:comment>Summary</xsl:comment>
		<xsl:for-each select="summary">
			<div class="sub-tab" _locID="Summary">
          SUMMARY                     <br/>
			</div>
			<div>
				<xsl:copy-of select="."/>
			</div>
			<br/>
		</xsl:for-each>
		<xsl:comment>TestSteps</xsl:comment>
		<xsl:for-each select="testSteps">
			<div class="avoid-page-break">
				<div class="sub-tab" _locID="Steps">
            <br/>
				</div>
				<xsl:choose>
					<xsl:when test="contains(../latestTestOutcomes/testResult/@Configuration, 'RF')">
						 <xsl:call-template name="testStepRF"/> 
					</xsl:when>
					 <xsl:when test="/planAndSuites/options/AlwaysThreeColumns='true'"> 
						 <xsl:call-template name="testStepRF"/> 
					</xsl:when>
					<xsl:otherwise>
						  <xsl:call-template name="testStepOther"/>  
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
		<xsl:comment>Parameters</xsl:comment>
		<xsl:for-each select="parameters">
			<div class="sub-tab" _locID="Parameters">                     PARAMETERS                   </div>
			<xsl:for-each select="sharedParameterDataSet">
				<div class ="sub-tab" _locID="SharedParameter">
            Shared parameter <xsl:call-template name="url-generator"/>: <xsl:value-of select="@title"/>
					<br/>
				</div>
			</xsl:for-each>
			<table>
				<tr class="shared-param-mapping">
					<xsl:for-each select="sharedParameterMapping">
						<th>
							<xsl:value-of select="@name"/>
						</th>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="parameterFieldName">
						<th>
							<xsl:value-of select="@name"/>
						</th>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="parametersData">
					<xsl:variable name="css-class">
						<xsl:choose>
							<xsl:when test="position() mod 2 = 0">table-row-even</xsl:when>
							<xsl:otherwise>table-row-odd</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr class="{$css-class}">
						<xsl:for-each select="parameterFieldData">
							<td>
								<xsl:value-of select="@name"/>
							</td>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:for-each>
		<xsl:for-each select="linksAndAttachments">
			<xsl:for-each select="links">
				<div class="sub-tab" _locID="Links">                   LINKS                     </div>
				<table>
					<tr>
						<th width="10%" _locID="Id">                        ID                         </th>
						<th width="20%" _locID="WorkItemType">           WorkItemType                         </th>
						<th width="20%" _locID="LinkType">               Link type                         </th>
						<th width="50%" _locID="Title">                    Title                         </th>
					</tr>
					<xsl:for-each select="link">
						<tr>
							<td>
								<xsl:call-template name="url-generator"/>
							</td>
							<td>
								<span>
									<xsl:value-of select="@workItemType"/>
								</span>
							</td>
							<td>
								<span>
									<xsl:value-of select="@type"/>
								</span>
							</td>
							<td>
								<span>
									<xsl:value-of select="@title"/>
								</span>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>

			<xsl:for-each select="attachments">
				<div class="sub-tab" _locID="Attachments">
            ATTACHMENTS
				</div>
				<table>
					<tr>
						<th width="28%" _locID="Name">                           Name                         </th>
						<th width="22%" _locID="Size">                           Size                         </th>
						<th width="20%" _locID="DateWhenAttachmentAdded">        Date Attached                         </th>
						<th width="30%" _locID="Comments">                       Comments                         </th>
					</tr>
					<xsl:for-each select="attachment">
						<tr>
							<td>
								<span>
									<a target="_blank">
										<xsl:attribute name="href">
											<xsl:value-of select="@url"/>
										</xsl:attribute>
										<xsl:value-of select="@name"/>
									</a>
								</span>
							</td>
							<td>
								<span>
									<xsl:value-of select="@sizeTxt"/>
								</span>
							</td>
							<td>
								<span>
									<xsl:value-of select="@date"/>
								</span>
							</td>
							<td>
								<span>
									<xsl:value-of select="@comments"/>
								</span>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:comment>Automation</xsl:comment>
		<xsl:for-each select="automation">
			<xsl:if test="*">
				<div class="sub-tab" _locID="AssociatedAutomation">            ASSOCIATED AUTOMATION                     </div>
				<xsl:apply-templates select="properties"/>
			</xsl:if>
		</xsl:for-each>
		<xsl:comment>Latest Test Outcome</xsl:comment>
	</xsl:template>


	<xsl:template match="properties">
		<table>
			<xsl:for-each select="property">
				<tr>
					<td class="property-name">
						<xsl:value-of select="@name"/>:
					</td>
					<td>
						<xsl:value-of select="@value"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="url-generator" >
		<a target="_blank">
			<xsl:attribute name="href">
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<xsl:value-of select="@id"/>
		</a>
	</xsl:template>
    
	<xsl:template name="childElementCopy">
		<xsl:copy-of select="node()"/>
	</xsl:template>
	<xsl:template name="testStepRF">
		<table>
			<xsl:for-each select="testStep">
				<xsl:variable name="css-class">
					<xsl:choose>
						<xsl:when test="position() mod 2 = 0">table-row-even</xsl:when>
						<xsl:otherwise>table-row-odd</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr class="{$css-class}">
					<td>
						<xsl:value-of select="@index"/>
                        <xsl:comment> What follows was used to prevent the ID from being wrapped on 2 lines because of a column too narrow. But added 
                            <br/>
                            <span style="font-size:12pt; color:white">  ؁  </span>
                        </xsl:comment>
					</td>
					<td>
						<xsl:for-each select="testStepAction">
							<xsl:call-template name="childElementCopy" />
						</xsl:for-each>
					</td>
                    <xsl:for-each select="stepAttachments/attachment">
                            <xsl:call-template name="sameRowAttachment" />
                    </xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>


	<xsl:template name="testStepOther">
		<table>
			<xsl:for-each select="testStep">
				<xsl:variable name="css-class">
					<xsl:choose>
						<xsl:when test="position() mod 2 = 0">table-row-even</xsl:when>
						<xsl:otherwise>table-row-odd</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<tr class="{$css-class}">
					<td>
						<xsl:value-of select="@index"/>
                        <xsl:comment> What follows was used to prevent the ID from being wrapped on 2 lines because of a column too narrow. But added 
                            <br/>
                            <span style="font-size:12pt; color:white">  ؁  </span>
                        </xsl:comment>
					</td>
					<td>
						<xsl:for-each select="testStepAction">
							<xsl:call-template name="childElementCopy" />
						</xsl:for-each>
					</td>
                    <xsl:for-each select="stepAttachments/attachment">
                            <xsl:call-template name="newRowAttachment" />
                    </xsl:for-each>
				</tr>					
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template  name="newRowAttachment">
        <tr>
            <td>
            </td>
            <td>
            <xsl:choose>
                <xsl:when test="@isImage='true'">
                    <img src="{@url}" alt="{@name}" />
                </xsl:when>
                <xsl:otherwise>
                    <a target="_blank" href="{@url}" class="embedAttachement" download="{@name}" >
                        <xsl:value-of select="@fileName" />
                    </a>
                </xsl:otherwise>
            </xsl:choose>
            <br />
            </td>
        </tr>
	</xsl:template>

	<xsl:template  name="sameRowAttachment">
        <td>
		<xsl:choose>
			<xsl:when test="@isImage='true'">
				<img src="{@url}" alt="{@name}" />
			</xsl:when>
			<xsl:otherwise>
				<a target="_blank" href="{@url}" class="embedAttachement" download="{@name}" >
					<xsl:value-of select="@fileName" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<br />
        </td>
	</xsl:template>

</xsl:stylesheet>