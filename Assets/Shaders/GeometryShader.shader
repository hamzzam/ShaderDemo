
Shader "ShaderDemo/GeometryShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Num ("Number", Range(0, 25)) = 1
		_Offset ("Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
		_EndScale ("End Scale", Vector) = (1.0, 1.0, 1.0, 1.0)
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
			uniform float4 _Offset;
			uniform float _Num;
			uniform float4 _EndScale;
			
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

			// Rotates the Coordinate sent as a parameter
			float4 CalculateRotation(float4 pos)
			{
				// How much rotation do we have right now?
				float rotation = 10 * _Time.y;

				// Create the Rotation Matrix
				float s, c;
				sincos(radians(rotation), s, c); // compute the sin and cosine
				float2x2 rotationMatrix = float2x2(c, -s, s, c);

				// Use the rotation matrix to rotate the vertices
				pos.xy = mul(pos.xy, rotationMatrix);
				return pos;
			}
			
			// The Geometry Shader
			[maxvertexcount(75)] // How many vertices can the shader output?
			void geometryShader(triangle VSOutput input[3], inout TriangleStream<VSOutput> OutputStream)
			{
				 VSOutput OUT = (VSOutput) 0;
				 float3 normal = normalize(cross(input[1].worldPosition.xyz - input[0].worldPosition.xyz, input[2].worldPosition.xyz - input[0].worldPosition.xyz));
				 float4 curOffset = float4(0.0, 0.0, 0.0, 0.0);
				 float4 curSize = float4(1.0, 1.0, 1.0, 1.0);
				 float4 scaleChange = (curSize - _EndScale) / _Num;
				
				 for(int k = 0; k < _Num; k++)
				 {
				 	for(int i = 0; i < 3; i++)
				 	{
				 		OUT.normal = normal;
				 		OUT.uv = input[i].uv;
						
				 		float4 curVertex = float4((curSize * input[i].worldPosition.xyz + curOffset), 1.0);
				 		curVertex = mul(unity_WorldToObject, curVertex);

				 		float4 rotatedVertex = float4(curVertex.x, curVertex.z, 1.0, 1.0);
				 		rotatedVertex = CalculateRotation(rotatedVertex);
				 		OUT.vertex = UnityObjectToClipPos(float4(rotatedVertex.x, curVertex.y, rotatedVertex.y, curVertex.w));

				 		OutputStream.Append(OUT);
				 	}
					
				 	curOffset.xyz += _Offset.xyz;
				 	curSize -= scaleChange;
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