
Shader "ShaderDemo/GeometryShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		//Other Options
		//Zwrite, Culling
		
		Pass
		{
			CGPROGRAM
			// Pragmas
			#pragma vertex vertexShader
			#pragma fragment fragmentShader
			 #pragma geometry geometryShader
			
			// Helper functions
			#include "UnityCG.cginc"
			
			// User Defined Variables
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			// Variables passed from script
			uniform float3 _PositionsArray[114];
			uniform float _InstanceCounter;
			
			// Base Input Structs
			struct VSInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};
			
			struct VSOutput
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 worldPosition : TEXCOORD1;
			};

			struct g2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};
			
			// The Vertex Shader 
			VSOutput vertexShader(VSInput IN)
			{
				VSOutput OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
				OUT.normal = IN.normal;
				OUT.worldPosition = mul(unity_ObjectToWorld, IN.vertex).xyz;
				return OUT;
			}
			
			// The Geometry Shader
			[maxvertexcount(113)] // How many vertices can the shader output?
			void geometryShader(triangle VSOutput input[3], inout TriangleStream<g2f> OutputStream)
			{
				 g2f OUT = (g2f) 0;
				 float3 normal = normalize(cross(input[1].worldPosition.xyz - input[0].worldPosition.xyz, input[2].worldPosition.xyz - input[0].worldPosition.xyz));
				
				 for(int k = 0; k < _InstanceCounter; k++)
				 {
				 	for(int i = 0; i < 3; i++)
				 	{
				 		OUT.normal = normal;
				 		OUT.uv = input[i].uv;

						float3 position = _PositionsArray[k].xyz;
						position.x += k;
				 		float4 curVertex = float4((input[i].worldPosition.xyz + position), 1.0);
				 		curVertex = mul(unity_WorldToObject, curVertex);

				 		OUT.vertex = UnityObjectToClipPos(curVertex);

				 		OutputStream.Append(OUT);
				 	}
					
				 	OutputStream.RestartStrip();
				}
			 }
			
			// The Fragment Shader
			fixed4 fragmentShader(VSOutput IN) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, IN.uv).rgba;
				
				// Some Fake Lighting
				float3 lightDir = float3(-1, 1, -1);
				float ndotl = dot(IN.normal, normalize(lightDir));
				
				// Output
				return col * ndotl;
			}
			ENDCG
		}
	}
}