//*****************************************************************************
//	The initial step in the bloom postprocessing effect; downsampling and luminance filtering.
//*****************************************************************************

float4x4 WorldMatrix;
float4x4 ViewMatrix;
float4x4 ProjectionMatrix;

sampler ScreenSampler : register( s0 );

float BrightPassThreshold = 0.85f;

//*****************************************************************************
struct VSDownSampleInput
{
    float3 position	: POSITION;
	float2 texCoord : TEXCOORD0;
};

struct VSDownSampleOutput
{
    float4 position	: POSITION;
	float2 texCoord : TEXCOORD0;
};

//*****************************************************************************
// Luminance Pass Functions and Program.
float4 Luminance( float4 color )
{
	//Simply use the magnitude of the color.
	float greyValue = length( color.rgb );
	float4 filterColor = color;

	//If the grey value of the pixel is above the threshold value, then include it.
	if( greyValue < BrightPassThreshold )
	{
		filterColor = ( float4 )0;
	}
	
	return filterColor;
}

float4 LuminancePS( VSDownSampleOutput psIn ) : COLOR0
{
	//Averaging the nearest values is for wussies.
	float4 color = tex2D( ScreenSampler, psIn.texCoord );

	return( Luminance( color ) );
}

//*****************************************************************************
technique LuminanceTech
{
	pass P0
	{
		PixelShader = compile ps_2_0 LuminancePS( );
	}
}