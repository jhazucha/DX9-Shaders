//--------------------------------------------------------------------------------------
// Catalyst3D : Built-in Landscape Shader Effect
//
// 1) Heightmap to use for (PER PIXEL) blending if you use the VB to just store heights
//    You will only be able to do per-vertex blending which will be limited to just 0-1
//    Clamped blend values. 
//--------------------------------------------------------------------------------------
float4x4 WorldViewProj : WORLDVIEWPROJECTION;
float4x4 WorldMatrix  : WORLD;

float LightIntensity;
float4 LightDirection;

float Tex0Scale;
float Tex0Weight;

float Tex1Scale;
float Tex1Weight;

float Tex2Scale;
float Tex2Weight;

float Tex3Scale;
float Tex3Weight;

// Textures
texture Tex0;
texture Tex1;
texture Tex2;
texture Tex3;
texture blnd1;


sampler samp1 = sampler_state
{
  Texture	= (Tex0);
  MinFilter = LINEAR;
  MipFilter = LINEAR;
  MagFilter = LINEAR;
};
sampler samp2 = sampler_state
{
  Texture	= (Tex1);
  MinFilter = LINEAR;
  MipFilter = LINEAR;
  MagFilter = LINEAR;
};
sampler samp3 = sampler_state
{
  Texture	= (Tex2);
  MinFilter = LINEAR;
  MipFilter = LINEAR;
  MagFilter = LINEAR;
};
sampler samp4 = sampler_state
{
  Texture	= (Tex3);
  MinFilter = LINEAR;
  MipFilter = LINEAR;
  MagFilter = LINEAR;
};
sampler samp5 = sampler_state
{
	Texture = (blnd1);
};

struct vertIN
{ 
  float4 position	: POSITION0;
  float3 normal		: NORMAL;
  float2 texCoord : TEXCOORD0;
};
struct vertOUT
{
	float4 position	: POSITION0;
	float2 texCoord	: TEXCOORD0;
	float3 normal	: TEXCOORD1;
};
struct pxIN
{
	float2 texCoord : TEXCOORD0;
	float3 normal   : TEXCOORD1;
};

float4 pShader(in pxIN IN) : COLOR0
{
	// scaled textures
	float4 tex1 = tex2D(samp1, IN.texCoord * Tex0Scale);
	float4 tex2 = tex2D(samp2, IN.texCoord * Tex1Scale);
	float4 tex3 = tex2D(samp3, IN.texCoord * Tex2Scale); 
	float4 tex4 = tex2D(samp4, IN.texCoord * Tex3Scale); 
	
	// non scaled textures
	float4 b1 = tex2D(samp1, IN.texCoord);
	float4 b2 = tex2D(samp2, IN.texCoord);
	float4 b3 = tex2D(samp3, IN.texCoord);
	float4 b4 = tex2D(samp4, IN.texCoord);
	
	// get the inverse
	float inverse = 1.0 / (b1.a + b2.a + b3.a + b4.a);
	
	// blend away		
	tex1.rgb *= b1.a * inverse;
	tex2.rgb *= b2.a * inverse;
	tex3.rgb *= b3.a * inverse;
	tex4.rgb *= b4.a * inverse;
	
	float3 final = (tex1 + tex2 + tex3 + tex4);
	
	return float4(final, 1.0f) * LightIntensity;
}

void vAmbient(in vertIN IN, out vertOUT OUT)
{
	// Transform our position
  OUT.position = mul(IN.position, WorldViewProj);

	// Transform our normal
  OUT.normal = mul(IN.normal, WorldMatrix);
  
  // Pass our texture coords
  OUT.texCoord = IN.texCoord;
 
}

technique Ambient
{
  pass p0
  {
		VertexShader = compile vs_1_1 vAmbient();
		PixelShader = compile ps_2_0 pShader();
  }
}